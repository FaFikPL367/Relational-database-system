# Skrypt do dodania pozycji dla pracowników
import pyodbc

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


# Pozycje dla pracowników
positions = [
    "Dyrektror platformy",
    "Koordynator webinarów",
    "Koordynator studiów",
    "Koordynator kursów",
    "Pracownik sekretariatu",
    "Wykładowca"
]


# Wstawienie danych do bazy
for position in positions:
    cursor.execute(
        "INSERT INTO Employees_Postions (PositionName) "
        "VALUES (?)",
        position
    )


# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()
