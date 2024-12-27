from faker import Faker
import pyodbc
import re


# Inicjalizajca Faker'a
fake = Faker('pl_PL')


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


# Generowanie danych użytkowników
users = []
for _ in range(150):
    user = {
        "FirstName": fake.first_name(),
        "LastName": fake.last_name(),
        "Phone": ''.join([str(fake.random_int(min=0, max=9)) for _ in range(9)]),
        "Email": fake.email(),
        "Address": fake.street_address(),
        "City": fake.city(),
        "PostalCode": fake.postcode()
    }

    # Dodanie użytkownika do listy
    users.append(user)


# Wstawienie danych do bazy
for user in users:
    cursor.execute(
        "INSERT INTO Users (FirstName, LastName, Phone, Email, Address, City, PostalCode)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        user["FirstName"],
        user["LastName"],
        user["Phone"],
        user["Email"],
        user["Address"],
        user["City"],
        user["PostalCode"]
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()