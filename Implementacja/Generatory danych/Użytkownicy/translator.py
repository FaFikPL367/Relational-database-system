from faker import Faker
import pyodbc


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
translators = []
for _ in range(30):
    translator = {
        "FirstName": fake.first_name(),
        "LastName": fake.last_name(),
        "Phone": ''.join([str(fake.random_int(min=0, max=9)) for _ in range(9)]),
        "Email": fake.email(),
        "Address": fake.street_address(),
        "City": fake.city(),
        "PostalCode": fake.postcode()
    }

    # Dodanie użytkownika do listy
    translators.append(translator)


# Wstawienie danych do bazy
for translator in translators:
    cursor.execute(
        "INSERT INTO Translators (FirstName, LastName, Phone, Email, Address, City, PostalCode)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        translator["FirstName"],
        translator["LastName"],
        translator["Phone"],
        translator["Email"],
        translator["Address"],
        translator["City"],
        translator["PostalCode"]
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()