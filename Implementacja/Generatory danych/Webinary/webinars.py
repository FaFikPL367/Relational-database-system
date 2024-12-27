from faker import Faker
import pyodbc
import random
import datetime


# Inicjalizajca Faker'a
fake = Faker()


# Połączenie z bazą danych
connection_string = ";".join([
    "DRIVER={ODBC Driver 17 for SQL Server}",
    "SERVER=dbmanage.lab.ii.agh.edu.pl",
    "DATABASE=u_psosnows",
    "UID=u_psosnows",
    "PWD=kzNvLBwmKiNq",
    "Encrypt=no",
    "CHARSET=UTF-8"
])

conn = pyodbc.connect(connection_string)

# Potrzebne do wykonywania poleceń SQL
cursor = conn.cursor()


# Pobranie z bazy informacji o parach tłumacz-język
query = 'Select * from Translators_Languages'
cursor.execute(query)
translators_languages = cursor.fetchall()


# Pobranie infromacji o ID nauczycieli
query = 'Select EmployeeID from Employees where PositionID = 6'
cursor.execute(query)
teachers = cursor.fetchall()


# Pobranie informacji o ID koordynatorów
query = 'Select EmployeeID from Employees where PositionID = 2'
cursor.execute(query)
coordinators = cursor.fetchall()


# Generowanie danych
webinars = []
for _ in range(5):
    # Zdecydowanie czy jeset tłumacza
    if random.randint(1, 2) == 1:
        translator_language = fake.random_element(translators_languages)
    else:
        translator_language = (None, 19)
    
    # Zdecydowanie o generowaniu daty startu
    date = fake.date_time_between(start_date="-30d", end_date="+30d")

    # Zdecydowanie o generowaniu linku do nagrania
    if date < datetime.datetime.now():
        recordingLink = fake.url()
    else:
        recordingLink = None

    webinar = {
        "Name": fake.sentence(nb_words=3),
        "Description": fake.text(),
        "DateAndBeginningTime": date,
        "Duration": '01:30:00',
        "CoordinatorID": fake.random_element(coordinators)[0],
        "TeacherID": fake.random_element(teachers)[0],
        "TranslatorID": translator_language[0],
        "Price": random.randint(100, 250),
        "LanguageID": translator_language[1],
        "MeetingLink": fake.url(),
        "RecordingLink": recordingLink
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
            @RecordingLink = ?       
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
        webinar["RecordingLink"]
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()