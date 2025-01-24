from faker import Faker
import pyodbc, random, uuid
from datetime import datetime, timedelta


# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(55)


# Inicjalizajca Faker'a
fake = Faker('pl_PL')


def courses(courses_quantity, plus_minus_days_for_courses, start_hour_courses, end_hour_courses, max_module_quantity_for_course, max_course_duration, connection_string, webinars_quantity):
    # Utworzenie połączenia
    conn = pyodbc.connect(connection_string)

    # Potrzebne do wykonywania poleceń SQL
    cursor = conn.cursor()
    cursor.execute("SET NOCOUNT ON;") # dla poprawy wydajności


    # 0. Dodanie typów modułów
    types = [
        'In-person',
        'Online Sync',
        'Online Async'
    ]


    # Wstawienie danych do bazy
    for tupe in types:
        cursor.execute(
            "INSERT INTO Types (TypeName)"
            "VALUES (?)",
            tupe
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie typów modułów do bazy")


    # 1. Pobranie ID nauczycieli
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName Like 'Wyk%adowca'")
    teachers = cursor.fetchall()
    teachers = [teacher[0] for teacher in teachers]

    # Wybieramy 1/3 nauczycieli
    teachers = teachers[10:30] # 20 nauczycieli

    # 2. Pobranie kordynatorów
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName = 'Koordynator kursów'")
    coordinators = cursor.fetchall()
    coordinators = [coordinator[0] for coordinator in coordinators]

    # 3. Pobranie tłumaczy
    cursor.execute("SELECT TranslatorID FROM Translators")
    translators = cursor.fetchall()
    translators = [translator[0] for translator in translators]
    translators.sort()

    # Wybieramy 1/3 tłumaczy
    translators = translators[10:20] # 10 tłumaczy

    # Pobranie par język-tłumacz
    cursor.execute("SELECT LanguageID, TranslatorID FROM Translators_Languages")
    translators_languages = cursor.fetchall()


    # 5. Wyznaczanie daty początkowej i końcowej kursu
    dates = []
    start_data_range = datetime.now() - timedelta(days=plus_minus_days_for_courses)
    end_data_range = datetime.now() + timedelta(days=plus_minus_days_for_courses)

    for i in range(1, courses_quantity+1):
        start_date = fake.date_between(start_date=start_data_range, end_date=end_data_range)
        end_time = start_date + timedelta(days=random.randint(1, max_course_duration))

        # Dodanie daty do kursu (wraz z indeksami)
        dates.append((i, start_date, end_time))


    # 6. Wygenerowanie reszty danych do kursów
    courses = []
    for i in range(1, courses_quantity+1):
        course = {
            "CoordinatorID": fake.random_element(coordinators),
            "Name": fake.sentence(nb_words=3),
            "Description": fake.text(),
            "StartDate": dates[i-1][1],
            "EndDate": dates[i-1][2],
            "Price": random.randint(100, 1000)
        }

        # Dodanie kursu do listy
        courses.append(course)

    # Wstawienie danych do bazy
    for course in courses:
        cursor.execute(
            """
                EXEC add_course
                    @CoordinatorID = ?,
                    @Name = ?,
                    @Description = ?,
                    @StartDate = ?,
                    @EndDate = ?,
                    @Price = ?,
                    @Status = ?
            """,
            course["CoordinatorID"],
            course["Name"],
            course["Description"],
            course["StartDate"],
            course["EndDate"],
            course["Price"],
            1
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie kursy do bazy")


    # 7. Wyznaczenie dat modułów
    modules_dates = []
    assigned_course_dates = {}  # Słownik przechowujący przypisane daty dla kursów
    for i in range(1, courses_quantity+1):
        # Wyznaczenie liczby modułów
        module_count = random.randint(1, max_module_quantity_for_course)
        module_dates_course = []

        assigned_datas_for_coures = assigned_course_dates.get(i, [])

        # Wyznaczenie dat modułów
        for j in range(module_count):
            while True:
                random_date = fake.date_time_between(start_date=dates[i-1][1], end_date=dates[i-1][2])
                random_hour = random.randint(start_hour_courses, end_hour_courses)
                random_minute = random.choice([0, 15, 30, 45])
                date = random_date.replace(hour=random_hour, minute=random_minute, second=0)

                conflict = False
                for assigned_date in assigned_datas_for_coures:
                    if (date >= assigned_date and date <= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date + timedelta(hours=1, minutes=30) >= assigned_date and date + timedelta(hours=1, minutes=30) <= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date <= assigned_date and date + timedelta(hours=1, minutes=30) >= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date >= assigned_date and date + timedelta(hours=1, minutes=30) <= assigned_date + timedelta(hours=1, minutes=30)):
                        conflict = True
                        break
                
                if not conflict:
                    module_dates_course.append(date)
                    assigned_datas_for_coures.append(date)
                    assigned_course_dates[i] = assigned_datas_for_coures
                    break


        for date in module_dates_course:
            modules_dates.append((i, date))


    # 8. Przypisanie nauczycieli do dat modułów
    teachers_dates = []
    assigned_teachers = {}

    for module_date in modules_dates:
        available_teacher = None

        # Termin do sprawdzenia dla nauczyciela
        start_time = module_date[1]
        end_time = start_time + timedelta(hours=1, minutes=30)

        for teacher in teachers:
            if teacher not in assigned_teachers:
                assigned_teachers[teacher] = []
            

            for assigned_time in assigned_teachers[teacher]:
                # Sprawdzenue czy terminy się na siebie nakładają
                if (start_time >= assigned_time and start_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (end_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time <= assigned_time and end_time >= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)):
                    break
            else:
                available_teacher = teacher
        
        if available_teacher:
            teachers_dates.append((available_teacher, start_time))
            assigned_teachers[available_teacher].append(start_time)
        else :
            print(f"Brak dostępnych nauczycieli dla daty: {date}")


    # 9. Wygenerowanie reszty danych do modułów
    modules = []

    for i in range(len(modules_dates)):
        module = {
            "TeacherID": teachers_dates[i][0],
            "CourseID": webinars_quantity + modules_dates[i][0],
            "Name": fake.sentence(nb_words=3),
            "Description": "",
            "DateAndBeginningTime": teachers_dates[i][1],
            "Duration": '01:30:00',
            "TypeID": random.randint(1, 3)
        }

        # Dodanie modułu do listy
        modules.append(module)

    # Wstawienie danych do bazy
    for module in modules:
        cursor.execute(
            """
            EXEC add_course_modules
                @TeacherID = ?,
                @CourseID = ?,
                @Name = ?,
                @Description = ?,
                @DateAndBeginningTime = ?,
                @Duration = ?,
                @TypeID = ?

            """,
            module["TeacherID"],
            module["CourseID"],
            module["Name"],
            module["Description"],
            module["DateAndBeginningTime"],
            module["Duration"],
            module["TypeID"]
        )    

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie modułów do bazy")



    # 10. Znaleźć moduły stacjonarne
    cursor.execute("SELECT ModuleID FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'In-person'")
    in_person_modules = cursor.fetchall()
    in_person_modules = [module[0] for module in in_person_modules]

    # 11. Znaleźć moduły online-synchroniczne
    cursor.execute("SELECT ModuleID FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Sync'")
    online_sync_modules = cursor.fetchall()
    online_sync_modules = [module[0] for module in online_sync_modules]

    # 12. Znaleźć moduły online-asynchroniczne
    cursor.execute("SELECT ModuleID FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Async'")
    online_async_modules = cursor.fetchall()
    online_async_modules = [module[0] for module in online_async_modules]


    # 13. Pobranie wszystkich dat modułów stacjonarnych
    cursor.execute("SELECT DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'In-person'")
    in_person_modules_dates = cursor.fetchall()
    in_person_modules_dates = [module[0] for module in in_person_modules_dates]

    # 10. Znaleźć moduły stacjonarne
    cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'In-person'")
    in_person_modules_dates = cursor.fetchall()

    # 11. Znaleźć moduły online-synchroniczne
    cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Sync'")
    online_sync_modules_dates = cursor.fetchall()

    # 12. Znaleźć moduły online-asynchroniczne
    cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Async'")
    online_async_modules = cursor.fetchall()

    # 13. Pobranie tłumaczy
    cursor.execute("SELECT TranslatorID FROM Translators")
    translators = cursor.fetchall()
    translators = [translator[0] for translator in translators]
    translators.sort()

    # Wybieramy 1/3 tłumaczy
    translators = translators[int(len(translators)/3): 2*int(len(translators)/3)]

    # Pobranie par język-tłumacz
    cursor.execute("SELECT LanguageID, TranslatorID FROM Translators_Languages")
    translators_languages = cursor.fetchall()

    # 14. Przypisanie tłumaczy do dat (stacjonarne)
    translators_dates_inperson = []
    assigned_translators = {}

    for (moduleid, date) in in_person_modules_dates: 
        available_translator = None

        # Zdecydowanie czy tłumacz ma być
        if random.randint(1, 2) == 2:
                translators_dates_inperson.append((None, date, 19, moduleid))
                continue

        # Termin do sprawdzenia dla tłumacza
        start_time = date
        end_time = date + timedelta(hours=1, minutes=30)

        for translator in translators:
            if translator not in assigned_translators:
                assigned_translators[translator] = []
            
            for assigned_time in assigned_translators[translator]:
                # Sprawdzenie czy terminy się na siebie nakładają
                if (start_time >= assigned_time and start_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (end_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time <= assigned_time and end_time >= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)):
                    break
            else:
                available_translator = translator
        
        if available_translator:
            # Odfiltrowanie języków, które tłmaczy tłumacz
            available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

            translators_dates_inperson.append((available_translator, date, random.choice(available_translator_languages), moduleid))
            assigned_translators[available_translator].append(date)
        else :
            print(f"Brak dostępnych tłumaczy dla daty: {date}")

    # 15. PRzypisanie tłumaczy do dat (online-synchroniczne)
    translators_dates_online_sync = []

    for (moduleid, date) in online_sync_modules_dates: 
        available_translator = None

        # Zdecydowanie czy tłumacz ma być
        if random.randint(1, 2) == 2:
            translators_dates_online_sync.append((None, date, 19, moduleid))
            continue

        # Termin do sprawdzenia dla tłumacza
        start_time = date
        end_time = date + timedelta(hours=1, minutes=30)

        for translator in translators:
            if translator not in assigned_translators:
                assigned_translators[translator] = []
            
            for assigned_time in assigned_translators[translator]:
                # Sprawdzenie czy terminy się na siebie nakładają
                if (start_time >= assigned_time and start_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (end_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time <= assigned_time and end_time >= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)):
                    break
            else:
                available_translator = translator
        
        if available_translator:
            # Odfiltrowanie języków, które tłmaczy tłumacz
            available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

            translators_dates_online_sync.append((available_translator, date, random.choice(available_translator_languages), moduleid))
            assigned_translators[available_translator].append(date)
        else :
            print(f"Brak dostępnych tłumaczy dla daty: {date}")


    # 16. Wygenerowanie danych do online-asynchronicznie
    modules_online_async = []

    for (moduleid, data) in online_async_modules:
        module_online_async = {
            "ModuleID": moduleid,
            "RecordnigLink": f"https://example.com/{uuid.uuid4()}"
        }

        modules_online_async.append(module_online_async)

    for module in modules_online_async:
        cursor.execute("""
            EXEC add_course_module_async
                @ModuleID = ?,
                @RecordingLink = ?
            """,
            module["ModuleID"],
            module["RecordnigLink"]
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślnie dodano modułów asynchrnonicznych do bazy")


    # 17. Wygenerowanie danych do online-synchronicznie
    modules_online_sync = []

    for (translator, date, language, moduleid) in translators_dates_online_sync:
        module_online_sync = {
            "ModuleID": moduleid,
            "MeetingLink": f"https://example.com/{uuid.uuid4()}",
            "RecordingLink": f"https://example.com/{uuid.uuid4()}" if date < datetime.now() else None,
            "TranslatorID": translator,
            "LanguageID": language
        }

        modules_online_sync.append(module_online_sync)


    for module in modules_online_sync:
        cursor.execute("""
            EXEC add_course_module_sync
                @ModuleID = ?,
                @MeetingLink = ?,
                @RecordingLink = ?,
                @TranslatorID = ?,
                @LanguageID = ?
            """,
            module["ModuleID"],
            module["MeetingLink"],
            module["RecordingLink"],
            module["TranslatorID"],
            module["LanguageID"]
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślnie dodano modułów synchronicznych do bazy")


    # 18. Wygenerowanie danych do modułów stacjonarnych
    modules_in_person = []

    for (translator, date, language, moduleid) in translators_dates_inperson:
        module_in_person = {
            "ModuleID": moduleid,
            "Classroom": random.randint(1, 1000),
            "TranslatorID": translator,
            "LanguageID": language,
            "Limit": random.randint(10, 30)
        }

        modules_in_person.append(module_in_person)

    for module in modules_in_person:
        cursor.execute("""
            EXEC add_course_module_in_person
                @ModuleID = ?,
                @Classroom = ?,
                @TranslatorID = ?,
                @LanguageID = ?,
                @Limit = ?
            """,
            module["ModuleID"],
            module["Classroom"],
            module["TranslatorID"],
            module["LanguageID"],
            module["Limit"]
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślnie dodano modułów stacjonarnych do bazy")


        
