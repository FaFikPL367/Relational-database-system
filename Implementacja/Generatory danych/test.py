from faker import Faker
import pyodbc, random, os, uuid
from dotenv import load_dotenv
from datetime import datetime, timedelta

Faker.seed(0)
random.seed(5)

# Inicjalizajca Faker'a
fake = Faker('pl_PL')

# Wczytanie zmiennych środowiskowych
load_dotenv()

# Wypisanie zmiennych środowiskowych
print("DB_SERVER:", os.getenv("DB_SERVER"))
print("DB_DATABASE:", os.getenv("DB_DATABASE"))
print("DB_USERNAME:", os.getenv("DB_USERNAME"))
print("DB_PASSWORD:", os.getenv("DB_PASSWORD"))

# Połączenie z bazą danych
connection_string = ";".join([
    "DRIVER={ODBC Driver 17 for SQL Server}",
    f"SERVER={os.getenv('DB_SERVER')}",
    f"DATABASE={os.getenv('DB_DATABASE')}",
    f"UID={os.getenv('DB_USERNAME')}",
    f"PWD={os.getenv('DB_PASSWORD')}",
    "Encrypt=no",
    "CHARSET=UTF-8"
])

# Utworzenie połączenia
conn = pyodbc.connect(connection_string)

# Potrzebne do wykonywania poleceń SQL
cursor = conn.cursor()
cursor.execute("SET NOCOUNT ON;") # dla poprawy wydajności

###########################################################

# 10. Znaleźć moduły stacjonarne
cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'In-person'")
in_person_modules_dates = cursor.fetchall()

# 11. Znaleźć moduły online-synchroniczne
cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Sync'")
online_sync_modules_dates = cursor.fetchall()

# 12. Znaleźć moduły online-asynchroniczne
cursor.execute("SELECT ModuleID, DateAndBeginningTime FROM Modules inner join Types on Modules.TypeID = Types.TypeID where TypeName = 'Online Async'")
online_async_modules = cursor.fetchall()

# 3. Pobranie tłumaczy
cursor.execute("SELECT TranslatorID FROM Translators")
translators = cursor.fetchall()
translators = [translator[0] for translator in translators]
translators.sort()

# Wybieramy 1/3 tłumaczy
translators = translators[int(len(translators)/3): 2*int(len(translators)/3)]

# Pobranie par język-tłumacz
cursor.execute("SELECT LanguageID, TranslatorID FROM Translators_Languages")
translators_languages = cursor.fetchall()

# 15. Przypisanie tłumaczy do dat (stacjonarne)
translators_dates_inperson = []
assigned_translators = {}

for (moduleid, date) in in_person_modules_dates: 
    available_translator = None

    # Zdecydowanie czy tłumacz ma być
    if random.randint(1, 2) == 2:
        translators_dates_inperson.append((None, date, 19, moduleid))
        continue

    # Termin do sprawdzenia dla tłumacza
    start_time = date
    end_time = date + timedelta(hours=1, minutes=30)

    for translator in translators:
        if translator not in assigned_translators:
            assigned_translators[translator] = []
        
        for assigned_time in assigned_translators[translator]:
            # Sprawdzenie czy terminy się na siebie nakładają
            if (start_time >= assigned_time and start_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                (end_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                (start_time <= assigned_time and end_time >= assigned_time + timedelta(hours=1, minutes=30)) or \
                (start_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)):
                break
        else:
            available_translator = translator
    
    if available_translator:
        # Odfiltrowanie języków, które tłmaczy tłumacz
        available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

        translators_dates_inperson.append((available_translator, date, random.choice(available_translator_languages), moduleid))
        assigned_translators[available_translator].append(date)
    else :
        print(f"Brak dostępnych tłumaczy dla daty: {date}")

# 16. PRzypisanie tłumaczy do dat (online-synchroniczne)
translators_dates_online_sync = []

for (moduleid, date) in online_sync_modules_dates: 
    available_translator = None

    # Zdecydowanie czy tłumacz ma być
    if random.randint(1, 2) == 2:
        translators_dates_online_sync.append((None, date, 19, moduleid))
        continue

    # Termin do sprawdzenia dla tłumacza
    start_time = date
    end_time = date + timedelta(hours=1, minutes=30)

    for translator in translators:
        if translator not in assigned_translators:
            assigned_translators[translator] = []
        
        for assigned_time in assigned_translators[translator]:
            # Sprawdzenie czy terminy się na siebie nakładają
            if (start_time >= assigned_time and start_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                (end_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)) or \
                (start_time <= assigned_time and end_time >= assigned_time + timedelta(hours=1, minutes=30)) or \
                (start_time >= assigned_time and end_time <= assigned_time + timedelta(hours=1, minutes=30)):
                break
        else:
            available_translator = translator
    
    if available_translator:
        # Odfiltrowanie języków, które tłmaczy tłumacz
        available_translator_languages = [language[0] for language in translators_languages if language[1] == available_translator]

        translators_dates_online_sync.append((available_translator, date, random.choice(available_translator_languages), moduleid))
        assigned_translators[available_translator].append(date)
    else :
        print(f"Brak dostępnych tłumaczy dla daty: {date}")


# 17. Wygenerowanie danych do online-asynchronicznie
modules_online_async = []

for (moduleid, data) in online_async_modules:
    module_online_async = {
        "ModuleID": moduleid,
        "RecordnigLink": f"https://example.com/{uuid.uuid4()}"
    }

    modules_online_async.append(module_online_async)

for module in modules_online_async:
    cursor.execute("""
        EXEC add_course_module_async
            @ModuleID = ?,
            @RecordingLink = ?
        """,
        module["ModuleID"],
        module["RecordnigLink"]
    )

# Zatwierdzenie zmian
conn.commit()
print("Pomyślnie dodano modułów asynchrnonicznych do bazy")


# 18. Wygenerowanie danych do online-synchronicznie
modules_online_sync = []

for (translator, date, language, moduleid) in translators_dates_online_sync:
    module_online_sync = {
        "ModuleID": moduleid,
        "MeetingLink": f"https://example.com/{uuid.uuid4()}",
        "RecordingLink": f"https://example.com/{uuid.uuid4()}" if date < datetime.now() else None,
        "TranslatorID": translator,
        "LanguageID": language
    }

    modules_online_sync.append(module_online_sync)


for module in modules_online_sync:
    cursor.execute("""
        EXEC add_course_module_sync
            @ModuleID = ?,
            @MeetingLink = ?,
            @RecordingLink = ?,
            @TranslatorID = ?,
            @LanguageID = ?
        """,
        module["ModuleID"],
        module["MeetingLink"],
        module["RecordingLink"],
        module["TranslatorID"],
        module["LanguageID"]
    )

# Zatwierdzenie zmian
conn.commit()
print("Pomyślnie dodano modułów synchronicznych do bazy")


# 19. Wygenerowanie danych do modułów stacjonarnych
modules_in_person = []

for (translator, date, language, moduleid) in translators_dates_inperson:
    module_in_person = {
        "ModuleID": moduleid,
        "Classroom": random.randint(1, 1000),
        "TranslatorID": translator,
        "LanguageID": language,
        "Limit": random.randint(10, 30)
    }

    modules_in_person.append(module_in_person)

for module in modules_in_person:
    cursor.execute("""
        EXEC add_course_module_in_person
            @ModuleID = ?,
            @Classroom = ?,
            @TranslatorID = ?,
            @LanguageID = ?,
            @Limit = ?
        """,
        module["ModuleID"],
        module["Classroom"],
        module["TranslatorID"],
        module["LanguageID"],
        module["Limit"]
    )

# Zatwierdzenie zmian
conn.commit()
print("Pomyślnie dodano modułów stacjonarnych do bazy")

