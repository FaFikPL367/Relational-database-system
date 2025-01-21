from faker import Faker
import pyodbc, random, os
from dotenv import load_dotenv

# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(5)


# Inicjalizajca Faker'a
fake = Faker('pl_PL')


def users(users_quantity, employees_quantity, webinars_coordinator_quantity, studies_coordinator_quantity, courses_coordinator_quantity, secretariat_quantity, lecturers_quantity, translators_quantity, how_many_languages, connection_string):
    # Sprawdzenie czy suma pracowników zgadza się z podaną ilością pracowników
    if (webinars_coordinator_quantity + studies_coordinator_quantity + courses_coordinator_quantity + secretariat_quantity + lecturers_quantity + 1) != employees_quantity:
        raise ValueError("Suma pracowników nie zgadza się z podaną ilością pracowników")

    # Utworzenie połączenia
    conn = pyodbc.connect(connection_string)

    # Potrzebne do wykonywania poleceń SQL
    cursor = conn.cursor()
    cursor.execute("SET NOCOUNT ON;") # dla poprawy wydajności


    # 1. Dodanie języków do słownika
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
    print("Pomyślne dodano języki do bazy danych")



    # 2. Dodanie pozycji pracowników
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
    print("Pomyślne dodano pozycje pracowników do bazy danych")



    # 3. Generowanie danych użytkowników
    users = []
    for _ in range(users_quantity):
        user = {
            "FirstName": fake.first_name(),
            "LastName": fake.last_name(),
            "Phone": fake.phone_number(),
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
    print("Pomyślne dodano użytkowników do bazy danych")



    # 4. Generowanie pracowników
    employees = []
    for _ in range(employees_quantity):
        employee = {
            "FirstName": fake.first_name(),
            "LastName": fake.last_name(),
            "Phone": fake.phone_number(),
            "Email": fake.email(),
            "Address": fake.street_address(),
            "City": fake.city(),
            "PostalCode": fake.postcode(),
            "PositionID": 0
        }

        # Dodanie użytkownika do listy
        employees.append(employee)


    # Przypisanie pracowników do pozycji 
    # (dyrektor, koordynator, koordynator, koordynator, sekretariat, nauczyciele)
    quntity = [0, 1, webinars_coordinator_quantity, studies_coordinator_quantity, courses_coordinator_quantity, secretariat_quantity, lecturers_quantity]
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
    print("Pomyślne dodano pracowników do bazy danych")



    # 5. Generowanie tłumaczy
    # Generowanie danych użytkowników
    translators = []
    for _ in range(translators_quantity):
        translator = {
            "FirstName": fake.first_name(),
            "LastName": fake.last_name(),
            "Phone": fake.phone_number(),
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
    print("Pomyślne dodano tłumaczy do bazy danych")


    # 6. Przyłączenie tłumaczy do języków
    # Generowanie danych 
    translators_languages_pars = [] # pary translator - język
    allowed_languages = [x for x in range(1, 25) if x != 19]
    for i in range(1, translators_quantity + 1):
        # Wylosowanie ile języków zna dany tłumacz
        languages = random.randint(1, how_many_languages+1)

        allowed_languages_copy = allowed_languages.copy()

        # Wylosowanie języków
        for _ in range(languages):
            value = random.choice(allowed_languages_copy)
            allowed_languages_copy.remove(value)

            translators_languages_pars.append({
                "TranslatorID": i,
                "LanguageID": value
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
    print("Pomyślne dodano tłumaczy do języków do bazy danych")

    # Zamknięcie połączenia
    cursor.close()
    conn.close()