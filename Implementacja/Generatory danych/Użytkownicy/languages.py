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
languages = [
    "francuski",
    "nidelandzki",
    "niemiecki",
    "włoski",
    "anielski",
    "duński",
    "grecki",
    "portugalski",
    "hiszpański",
    "fiński",
    "szwedzki",
    "czeski",
    "słowacki",
    "węgierski",
    "estoński",
    "łotewski",
    "litewski",
    "maltański",
    "polski",
    "słoweński",
    "bułgarski",
    "irlandzki",
    "rumuński",
    "chorwacki"
]

# Wstawienie danych do bazy
for language in languages:
    cursor.execute(
        "INSERT INTO Languages (LanguageName)"
        "VALUES (?)",
        language
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()