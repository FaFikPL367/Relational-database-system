from faker import Faker
import pyodbc, random, os
from datetime import datetime, timedelta
import uuid

# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(5)

# Inicjalizajca Faker'a
fake = Faker('pl_PL')


def webinars(webinars_quantity, plus_minus_days_for_webinars, start_hour_webinars, end_hour_webinars, connection_string):
    # Utworzenie połączenia
    conn = pyodbc.connect(connection_string)

    # Potrzebne do wykonywania poleceń SQL
    cursor = conn.cursor()
    cursor.execute("SET NOCOUNT ON;") # dla poprawy wydajności

    # 0. Dodanie kategorii
    categories = [
        "Webinar",
        "Course",
        "Studies",
        "Meeting",
        "Reunion"
    ]

    # Wstawienie danych do bazy
    for category in categories:
        cursor.execute(
            "INSERT INTO Categories (Name)"
            "VALUES (?)",
            category
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie kategorii (kategorie ofert) do bazy")

    # 1. Pobranie ID nauczycieli
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName Like 'Wyk%adowca'")
    teachers = cursor.fetchall()
    teachers = [teacher[0] for teacher in teachers]

    # Wybieramy 1/3 nauczycieli
    teachers = teachers[0: int(len(teachers)/3)]


    # 2. Pobranie kordynatorów
    cursor.execute("SELECT EmployeeID FROM Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID where PositionName = 'Koordynator webinarów'")
    coordinators = cursor.fetchall()
    coordinators = [coordinator[0] for coordinator in coordinators]


    # 3. Pobranie tłumaczy
    cursor.execute("SELECT TranslatorID FROM Translators")
    translators = cursor.fetchall()
    translators = [translator[0] for translator in translators]
    translators.sort()

    # Wybieramy 1/3 tłumaczy
    translators = translators[0: int(len(translators)/3)]

    # Pobranie par język-tłumacz
    cursor.execute("SELECT LanguageID, TranslatorID FROM Translators_Languages")
    translators_languages = cursor.fetchall()


    # 5. Wygenerowanie terminów odbywania się webinarów
    dates = []
    start_date = datetime.now() - timedelta(days=plus_minus_days_for_webinars)
    end_date = datetime.now() + timedelta(days=plus_minus_days_for_webinars)

    for i in range(webinars_quantity):
        # Generowanie losowej daty
        random_date = fake.date_time_between(start_date=start_date, end_date=end_date)

        # Losowanie godziny z jakiegoś przedziału
        random_hour = random.randint(start_hour_webinars, end_hour_webinars)

        # Losowanie minuty
        random_minute = random.choice([0, 15, 30, 45])

        # Utworzenie daty
        date = random_date.replace(hour=random_hour, minute=random_minute, second=0)

        # Dodanie daty do listy
        dates.append(date)
    dates.sort()


    # 6. Przypisanie nauczycieli do dat
    teachers_dates = []
    assigned_teachers = {}

    for date in dates:
        available_teacher = None

        # Termin do sprawdzenia dla nauczyciela
        start_time = date
        end_time = date + timedelta(hours=1, minutes=30)

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
            teachers_dates.append((available_teacher, date))
            assigned_teachers[available_teacher].append(date)
        else :
            print(f"Brak dostępnych nauczycieli dla daty: {date}")
        

    # 7. Przypisanie tłumaczy do dat
    translators_dates = []
    assigned_translators = {}

    for date in dates: 
        available_translator = None

        # Zdecydowanie czy tłumacz ma być
        if random.randint(1, 2) == 2:
            translators_dates.append((None, date))
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

            translators_dates.append((available_translator, date, random.choice(available_translator_languages)))
            assigned_translators[available_translator].append(date)
        else :
            print(f"Brak dostępnych tłumaczy dla daty: {date}")


    # 8. Generowanie reszty danych do każdego webinaru
    webinars = []
    for i in range(webinars_quantity):
        webinar = {
            "Name": fake.sentence(nb_words=3),
            "Description": fake.text(),
            "DateAndBeginningTime": dates[i],
            "Duration": '01:30:00',
            "CoordinatorID": fake.random_element(coordinators),
            "TeacherID": teachers_dates[i][0],
            "TranslatorID": translators_dates[i][0],
            "Price": random.randint(100, 250),
            "LanguageID": translators_dates[i][2] if translators_dates[i][0] else 19,
            "MeetingLink": f"https://example.com/{uuid.uuid4()}",
            "RecordingLink": f"https://example.com/{uuid.uuid4()}" if dates[i] < datetime.now() else None
        }

        # Dodanie webinaru do listy
        webinars.append(webinar)

    # Wstawienie danych do bazy
    for webinar in webinars:
        cursor.execute(
            """
            EXEC add_webinar
                @Name = ?,
                @Description = ?,
                @DateAndBeginningTime = ?,
                @Duration = ?,
                @CoordinatorID = ?,
                @TeacherID = ?,
                @TranslatorID = ?,
                @Price = ?,
                @LanguageID = ?,
                @MeetingLink = ?,
                @RecordingLink = ?,       
                @Status = ?
            """,
            webinar["Name"],
            webinar["Description"],
            webinar["DateAndBeginningTime"],
            webinar["Duration"],
            webinar["CoordinatorID"],
            webinar["TeacherID"],
            webinar["TranslatorID"],
            webinar["Price"],
            webinar["LanguageID"],
            webinar["MeetingLink"],
            webinar["RecordingLink"],
            1
        )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie webinarów do bazy")

    # Zamknięcie połączenia
    cursor.close()
    conn.close()

    

    

        



