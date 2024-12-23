from faker import Faker
import pyodbc


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


# Generowanie danych użytkowników
employees = []
for _ in range(30):
    employee = {
        "FirstName": fake.first_name(),
        "LastName": fake.last_name(),
        "Phone": ''.join([str(fake.random_int(min=0, max=9)) for _ in range(9)]),
        "Email": fake.email(),
        "Address": fake.street_address(),
        "City": fake.city(),
        "PostalCode": fake.postcode(),
        "PositionID": 0
    }

    # Dodanie użytkownika do listy
    employees.append(employee)


# Przypisanie pracowników do pozycji
quntity = [0, 1, 5, 5, 5, 2, 12]
index = 1
for user in employees:
    if quntity[index] != 0:
        user["PositionID"] = index
        quntity[index] -= 1
    else:
        index += 1
        user["PositionID"] = index
        quntity[index] -= 1


# Wstawienie danych do bazy
for employee in employees:
    cursor.execute(
        "INSERT INTO Employees (FirstName, LastName, Phone, Email, Address, City, PostalCode, PositionID) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        employee["FirstName"],
        employee["LastName"],
        employee["Phone"],
        employee["Email"],
        employee["Address"],
        employee["City"],
        employee["PostalCode"],
        employee["PositionID"]
    )


# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()