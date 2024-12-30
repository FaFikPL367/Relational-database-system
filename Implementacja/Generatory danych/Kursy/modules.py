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


# Pobranie informacji o ID nayczycieli
query = 'Select EmployeeID from Employees where PositionID = 6'
cursor.execute(query)
teachers = cursor.fetchall()


# Pobranie informacji o kursach
query = 'Select CourseID, StartDate, EndDate from Courses'
cursor.execute(query)
courses = cursor.fetchall()


# Generowanie danych
modules = []
for _ in range(5):
    # Wybranie kursu
    course = fake.random_element(courses)

    # Wygenerowanie daty
    date = fake.date_time_between(start_date=course[1], end_date=course[2])

    module = {
        "TeacherID": fake.random_element(teachers)[0],
        "CourseID": course[0],
        "Name": fake.sentence(nb_words=3),
        "Description": fake.text(),
        "DateAndBeginningTime": date,
        "Duration": '01:30:00',
        "TypeID": random.randint(1, 3)
    }

    # Dodanie modułu do listy
    modules.append(module)


# Wstawienie danych do bazy
for module in modules:
    cursor.execute(
        "INSERT INTO Modules (TeacherID, CourseID, Name, Description, DateAndBeginningTime, Duration, TypeID)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
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

# Zamknięcie połączenia
cursor.close()
conn.close()

