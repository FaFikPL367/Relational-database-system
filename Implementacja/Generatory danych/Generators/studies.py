from faker import Faker
import pyodbc, random, uuid, os
from datetime import datetime, timedelta
from dotenv import load_dotenv


# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(45)


# Inicjalizajca Faker'a
fake = Faker("pl_PL")
fake_for_practices = Faker()


def studies(studies_quantity, max_quantity_subjects_in_study, min_quantity_subjects_in_study, practices_quantity, start_hour_studies, end_hour_studies, reunion_quantity, connection_string, courses_quantity, webinars_quantity, plus_minus_days_for_studies, semestr_quantity, one_reunion_length):
    # Utworzenie połączenia z bazą danych
    conn = pyodbc.connect(connection_string)

    # Potrzebne do wykonania poleceń SQL
    cursor = conn.cursor()
    cursor.execute("SET NOCOUNT ON") # dla poprawy wydajności

    # 0. Pobranie potrzebnych danych
    # 0.1 Pobranie ID koordynatorów studiów
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName = 'Koordynator studiów'")
    studies_coordinators = cursor.fetchall()
    studies_coordinators = [coordinator[0] for coordinator in studies_coordinators]
    studies_coordinators.sort()

    # 0.2 Pobranie ID nauczycieli
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName Like 'Wyk%adowca'")
    lecturers = cursor.fetchall()
    lecturers = [lecturer[0] for lecturer in lecturers]
    lecturers.sort()

    # Wybór 1/3 nauczycieli
    lecturers = lecturers[30:] # 50 nauczycieli

    # 0.3 Pobranie ID tłumaczy
    cursor.execute("SELECT TranslatorID FROM Translators")
    translators = cursor.fetchall()
    translators = [translator[0] for translator in translators]
    translators.sort()

    translators = translators[20:]

    # 0.4 Pobranie par tłumacz-język
    cursor.execute("SELECT LanguageID, TranslatorID FROM Translators_Languages")
    translators_languages = cursor.fetchall()


    # 1. Wygenerowanie praktykantów
    practices = []
    for _ in range(practices_quantity):
        practice = {
            "Description": fake_for_practices.text(max_nb_chars=200),
            "CompanyName": fake_for_practices.name(),
            "Country": fake_for_practices.country()[:30],
            "City": fake_for_practices.city(),
            "Address": fake_for_practices.address()[:50],
            "Phone": fake_for_practices.phone_number()[:random.randint(9, 20)],
            "Email": f"{fake.user_name()}_{uuid.uuid4().hex[:8]}@{fake.free_email_domain()}",
        }

        practices.append(practice)
    
    # Dodanie praktykantów do bazy
    for practice in practices:
        cursor.execute(
            """
                INSERT INTO Practices (Description, CompanyName, Country, City, Address, Phone, Email)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            practice["Description"],
            practice["CompanyName"],
            practice["Country"],
            practice["City"],
            practice["Address"],
            practice["Phone"],
            practice["Email"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie praktykantów do bazy")


    start_studies_date = datetime.now() - timedelta(days=plus_minus_days_for_studies)
    end_studies_date = datetime.now() + timedelta(days=plus_minus_days_for_studies)
    studies = []
    # 2. Wygenerowanie studiów
    for _ in range(studies_quantity):
        # Wylosowanie daty rozpoczęcia i zakończenia studiów
        start_date = fake.date_time_between_dates(datetime_start=start_studies_date, datetime_end=end_studies_date)
        end_date = start_date + timedelta(days=3*365) # Zawsze trwają 3 lata

        # Wylosowanie reszty danych
        studie = {
            "CoordinatorID": random.choice(studies_coordinators),
            "Name": fake.sentence(nb_words=3),
            "Description": fake.text(max_nb_chars=200),
            "StartDate": start_date.date(),
            "EndDate": end_date.date(),
            "Price": random.randint(1000, 5000),
        }

        studies.append(studie)
    
    #Dodanie studiów do bazy
    for studie in studies:
        cursor.execute(
            """
                EXEC add_studie
                    @CoordinatorID = ?,
                    @Name = ?,
                    @Description = ?,
                    @StartDate = ?,
                    @EndDate = ?,
                    @Price = ?,
                    @Status = ?
            """,
            studie["CoordinatorID"],
            studie["Name"],
            studie["Description"],
            studie["StartDate"],
            studie["EndDate"],
            studie["Price"],
            1
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie studiów do bazy")


    # 3. Wygenerowanie zjazdów
    reunions = []
    for index, studie in enumerate(studies):
        # Dla każdych studiów trzeba wygenerować odpowiednią liczbę zjazdów dla każdego semstru
        for i in range(semestr_quantity):
            # Wyznaczenie daty początkowej i końcowej semestru
            start_date_semestr = studie["StartDate"] + timedelta(days = int(3*365 / semestr_quantity)) * i
            end_date_semestr = start_date_semestr + timedelta(days = int(3*365 / semestr_quantity))

            # Wyznaczenie co ile ma odbywać się zjazd
            days_between_reunions = int((end_date_semestr - start_date_semestr).days / reunion_quantity)

            # Generowanie odpowiedniej liczby zjazdów w semestrze
            for j in range(reunion_quantity):
                # Wyznaczenie daty każdego zjazdu w danym semestrze
                start_date_reunion = start_date_semestr + timedelta(days=days_between_reunions) * j
                end_date_reunion = start_date_reunion + timedelta(days=one_reunion_length)

                # Wygenerowanie pojedynczego zjazdu
                reunion = {
                    "StudiesID": webinars_quantity + courses_quantity + index + 1,
                    "StartDate": start_date_reunion,
                    "EndDate": end_date_reunion,
                }

                reunions.append(reunion)
    
    # Dodanie zjazdów do bazy
    for reunion in reunions:  
        cursor.execute(
            """
                EXEC add_reunion
                    @StudiesID = ?,
                    @StartDate = ?,
                    @EndDate = ?,
                    @Status = ?
            """,
            reunion["StudiesID"],
            reunion["StartDate"],
            reunion["EndDate"],
            1
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie zjazdów do bazy")


    # 4. Wygenerowanie przedmiotów
    subjects = []
    for index, studie in enumerate(studies):
        # Wygenerowanie ilości przedmiotów na jednych studiach
        subjects_quantity = random.randint(min_quantity_subjects_in_study, max_quantity_subjects_in_study)

        # Wygenerowanie reszty danych dla przedmiotów
        for _ in range(subjects_quantity):
            subject = {
                "StudiesID": webinars_quantity + courses_quantity + index + 1,
                "Name": fake.sentence(nb_words=3),
                "Description": fake.text(max_nb_chars=200)
            }

            subjects.append(subject)
    
    # Dodanie przedmiotów do bazy
    for subject in subjects:
        cursor.execute(
            "INSERT INTO Subjects (StudiesID, Name, Description)"
            "VALUES (?, ?, ?)",
            subject["StudiesID"],
            subject["Name"],
            subject["Description"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie przedmiotów do bazy")


    # 5. Wygenerowanie dat spotkań do zjazdów
    assigned_datas_for_reunions = {}
    meetings = []
    for index, reunion in enumerate(reunions):
        # Pobranie daty początkowej i końcowej zjazdu
        start_date_reunion = reunion["StartDate"]
        end_date_reunion = reunion["EndDate"]

        # Wyznaczyć ID przedmiotów dla danego zjazdu (czyli danego stidium)
        cursor.execute(
            "SELECT SubjectID FROM Subjects WHERE StudiesID = ?",
            reunion["StudiesID"]
        )
        subjects_ids_for_reunion = cursor.fetchall()
        subjects_ids_for_reunion = [subject[0] for subject in subjects_ids_for_reunion]

        # Wyznaczenie dat do spotkań tak abu spotkania w jednym znazdzie się nie nakładały
        assigned_datas_for_current_reunion = assigned_datas_for_reunions.get(index, [])

        for subject_index in subjects_ids_for_reunion:
            while True:
                # Wyznaczenie daty i godziny spotkania
                random_date = fake.date_time_between_dates(datetime_start=start_date_reunion, datetime_end=end_date_reunion)
                random_hour = random.randint(start_hour_studies, end_hour_studies)
                random_minute = random.choice([0, 15, 30, 45])
                date = random_date.replace(hour=random_hour, minute=random_minute, second=0)

                # Sprawdzamy czy nie ma konfliktu w danym zjeździe
                conflict = False
                for assigned_date in assigned_datas_for_current_reunion:
                    if (date >= assigned_date and date <= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date + timedelta(hours=1, minutes=30) >= assigned_date and date + timedelta(hours=1, minutes=30) <= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date <= assigned_date and date + timedelta(hours=1, minutes=30) >= assigned_date + timedelta(hours=1, minutes=30)) or \
                        (date >= assigned_date and date + timedelta(hours=1, minutes=30) <= assigned_date + timedelta(hours=1, minutes=30)):
                        conflict = True
                        break

                # Jeżeli nie ma konfliktu to przyjmujemy datę danego spotkania
                if not conflict:
                    assigned_datas_for_current_reunion.append(date)
                    assigned_datas_for_reunions[index] = assigned_datas_for_current_reunion
                    break
            
            # Dodanie ID zjazdu, daty spotkania i ID przedmiotu do listy spotkań
            meeting = {
                "ReunionID": index+1,
                "DateAndBeginningTime": date,
                "SubjectID": subject_index
            }

            meetings.append(meeting)
        
    
    # 6. Dodanie do każdego spotkania nauczyciela bez konfliktów
    assigned_lecturers = {}

    for meeting in meetings:
        available_lecturer = None

        # Pobranie daty spotkania, którą trzba sprawdzić dla danego nauczyciela
        start_date = meeting["DateAndBeginningTime"]
        end_date = start_date + timedelta(hours=1, minutes=30)

        # Przejście przez wszystkich nauczycieli i przypisanie do spotkań
        for lecture in lecturers:
            if lecture not in assigned_lecturers:
                assigned_lecturers[lecture] = []
            
            # Sprawdzenie czy dany nauczyciel moze prowadzić spotkanie w danym terminie
            for assigned_time in assigned_lecturers[lecture]:
                if (start_date >= assigned_time and start_date <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (end_date >= assigned_time and end_date <= assigned_time + timedelta(hours=1, minutes=30)) or \
                    (start_date <= assigned_time and end_date >= assigned_time + timedelta(hours=1, minutes=30)):
                    break
            else:
                available_lecturer = lecture
            
        # Sprawdzamy czy jakiś nauczyciel został przypisany
        if available_lecturer:
            meeting["TeacherID"] = available_lecturer
            assigned_lecturers[available_lecturer].append(start_date)
        else:
            print(f"Brak dostępnych nauczycieli dla daty: {date}")
    

    # 7. Dogenerowanie reszty danych do spotkań
    for meeting in meetings:
        meeting["Duration"] = '01:30:00'
        meeting["Price"] = random.randint(100, 200)
        meeting["TypeID"] = random.randint(1, 3)
        meeting["Status"] = 1
    
    # Dodanie spotkań do bazy
    for meeting in meetings:
        cursor.execute(
            """
                EXEC add_meeting
                    @TeacherID = ?,
                    @SubjectID = ?,
                    @ReunionID = ?,
                    @DateAndBeginningTime = ?,
                    @Duration = ?,
                    @Price = ?,
                    @TypeID = ?,
                    @Status = ?
            """,
            meeting["TeacherID"],
            meeting["SubjectID"],
            meeting["ReunionID"],
            meeting["DateAndBeginningTime"],
            meeting["Duration"],
            meeting["Price"],
            meeting["TypeID"],
            meeting["Status"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie spotkań do bazy")


    # 8. Znaleznie spotkań stacjonarnych
    cursor.execute("Select MeetingID, DateAndBeginningTime from Meetings inner join Types on Meetings.TypeID = Types.TypeID where TypeName = 'In person'")
    in_person_meetings = cursor.fetchall()

    # 9. Znaleznie spotkań online-synchroniczne
    cursor.execute("Select MeetingID, DateAndBeginningTime from Meetings inner join Types on Meetings.TypeID = Types.TypeID where TypeName = 'Online sync'")
    online_sync_meetings = cursor.fetchall()

    # 10. Znalezienie spotkań online-asynchronicznie
    cursor.execute("Select MeetingID, DateAndBeginningTime from Meetings inner join Types on Meetings.TypeID = Types.TypeID where TypeName = 'Online async'")
    online_async_meetings = cursor.fetchall()


    # 11. Wygenrowanie spoktań online-asynchronicznie
    meetings_online_async = []
    for (meetingid, meeting_date) in online_async_meetings:
        meeting_online_async = {
            "MeetingID": meetingid,
            "RecordingLink": f"https://example.com/{uuid.uuid4()}"
        }

        meetings_online_async.append(meeting_online_async)
    
    for meeting in meetings_online_async:
        cursor.execute(
            """
                EXEC add_meeting_async
                    @MeetingID = ?,
                    @RecordingLink = ?
            """,
            meeting["MeetingID"],
            meeting["RecordingLink"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie spotkań online-asynchronicznie do bazy")


    # 12. Przypisanie tłumaczy do dat spotkań stacjoanrnych
    assigned_translators = {}
    meetings_online_inperson = []

    for (meetingid, meeting_date) in in_person_meetings:
        available_translator = None

        # Zadecydowanie czy dodajemy tłumacza
        if random.randint(1, 2) == 2:
            meeting = {
                "MeetingID": meetingid,
                "Classroom": random.randint(1001, 2000),
                "TranslatorID": None,
                "LanguageID": 19,
                "Limit": random.randint(10, 30)
            } 

            meetings_online_inperson.append(meeting)
            continue
            
        # Jeżeli jednak chcemy mieć tłumacza
        start_time = meeting_date
        end_time = start_time + timedelta(hours=1, minutes=30)

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
            
        # Sprawdzamy czy tłumacz został wybrany
        if available_translator:
            # Odfiltrowanie języków, które tłumaczy tłumacz
            available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

            meeting = {
                "MeetingID": meetingid,
                "Classroom": random.randint(1001, 2000),
                "TranslatorID": available_translator,
                "LanguageID": random.choice(available_translator_languages),
                "Limit": random.randint(10, 30)
            }

            meetings_online_inperson.append(meeting)
            assigned_translators[available_translator].append(start_time)
        else:
            print(f"Brak dostępnych tłumaczy dla daty: {date}")
    

    # 13. Przypisanie tłumaczy do spotkań online-synchronicznie
    meetings_online_sync = []

    for (meetingid, meeting_date) in online_sync_meetings:
        available_translator = None

        # Zadecydowanie czy dodajemy tłumacza
        if random.randint(1, 2) == 2:
            meeting = {
                "MeetingID": meetingid,
                "MeetingLink": f"https://example.com/{uuid.uuid4()}",
                "RecordingLink": f"https://example.com/{uuid.uuid4()}" if meeting_date < datetime.now() else None,
                "TranslatorID": None,
                "LanguageID": 19
            } 

            meetings_online_sync.append(meeting)
            continue
            
        # Jeżeli jednak chcemy mieć tłumacza
        start_time = meeting_date
        end_time = start_time + timedelta(hours=1, minutes=30)

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
            
        # Sprawdzamy czy tłumacz został wybrany
        if available_translator:
            # Odfiltrowanie języków, które tłumaczy tłumacz
            available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

            meeting = {
                "MeetingID": meetingid,
                "MeetingLink": f"https://example.com/{uuid.uuid4()}",
                "RecordingLink": f"https://example.com/{uuid.uuid4()}" if meeting_date < datetime.now() else None,
                "TranslatorID": available_translator,
                "LanguageID": random.choice(available_translator_languages)
            }

            meetings_online_sync.append(meeting)
            assigned_translators[available_translator].append(start_time)
        else:
            print(f"Brak dostępnych tłumaczy dla daty: {date}")
    

    # 14. Dodanie spotkań stacjonarnych do bazy
    for meeting in meetings_online_inperson:
        cursor.execute(
            """
                EXEC add_meeting_in_person
                    @MeetingID = ?,
                    @Classroom = ?,
                    @TranslatorID = ?,
                    @LanguageID = ?,
                    @Limit = ?
            """,
            meeting["MeetingID"],
            meeting["Classroom"],
            meeting["TranslatorID"],
            meeting["LanguageID"],
            meeting["Limit"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie spotkań stacjonarnych do bazy")


    # 15. Dodanie spotkań online-synchronicznych do bazy
    for meeting in meetings_online_sync:
        cursor.execute(
            """
                EXEC add_meeting_sync
                    @MeetingID = ?,
                    @MeetingLink = ?,
                    @RecordingLink = ?,
                    @TranslatorID = ?,
                    @LanguageID = ?
            """,
            meeting["MeetingID"],
            meeting["MeetingLink"],
            meeting["RecordingLink"],
            meeting["TranslatorID"],
            meeting["LanguageID"]
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie spotkań online-synchronicznych do bazy")

    

