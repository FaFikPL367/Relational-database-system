from faker import Faker
import pyodbc
import random


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


# Generowanie danych 
translators_languages_pars = [] # pary translator - język
for i in range(1, 31):
    # Wylosowanie ile języków zna dany tłumacz
    languages = random.randint(1, 3)

    # Wylosowanie języków
    for _ in range(languages):
        translators_languages_pars.append({
            "TranslatorID": i,
            "LanguageID": random.randint(1, 24)
        })
        

# Wstawienie danych do bazy
for translator_language in translators_languages_pars:
    cursor.execute(
        "INSERT INTO Translators_Languages (TranslatorID, LanguageID) "
        "VALUES (?, ?)",
        translator_language["TranslatorID"],
        translator_language["LanguageID"]
    )

# Zatwierdzenie zmian
conn.commit()

# Zamknięcie połączenia
cursor.close()
conn.close()