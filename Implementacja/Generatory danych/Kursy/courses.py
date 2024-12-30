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


# Pobranie informacji o ID koordynatorów kursów
query = 'Select EmployeeID from Employees where PositionID = 4'
cursor.execute(query)
coordinators = cursor.fetchall()


# Generowanie danych
courses = []
for _ in range(5):
    # Generowanie daty startu i końca
    startDate = fake.date_between(start_date="-30d", end_date="+30d")
    duration = random.randint(1, 30)
    endDate = fake.date_between_dates(date_start=startDate, date_end=startDate + datetime.timedelta(days=duration))

    course = {
        "CoordinatorID": fake.random_element(coordinators)[0],
        "Name": fake.sentence(nb_words=3),
        "Description": fake.text(),
        "StartDate": startDate,
        "EndDate": endDate,
        "Price": random.randint(100, 1000),
        "Status": True if random.randint(0, 1) == 1 else False
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
        course["Status"]
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()