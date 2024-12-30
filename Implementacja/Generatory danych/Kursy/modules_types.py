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


# Dane do dodania
types = [
    'In-person',
    'Online Sync',
    'Online Async',
    'Hybrid'
]


# Wstawienie danych do bazy
for tupe in types:
    cursor.execute(
        "INSERT INTO Modules_Types (TypeName)"
        "VALUES (?)",
        tupe
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()