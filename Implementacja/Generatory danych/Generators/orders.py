from faker import Faker
import pyodbc, random, uuid, os
from datetime import datetime, timedelta
from dotenv import load_dotenv


# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(65)


# Inicjalizajca Faker'a
fake = Faker('pl_PL')


def orders(connection_string, min_users_quantity_for_webinars, max_users_quantity_for_webinars, min_users_quantity_for_courses, max_users_quantity_for_courses):
    # Utworzenie połączenia
    conn = pyodbc.connect(connection_string)

    # Potrzebne do wykonywania poleceń SQL
    cursor = conn.cursor()
    cursor.execute("SET NOCOUNT ON;") # dla poprawy wydajności

    # 0. Pobrać ID użytkowników
    cursor.execute("SELECT UserID FROM Users")
    users = cursor.fetchall()
    users = [users[0] for users in users]


    # 1. Pobrać ID webinarów
    cursor.execute("SELECT WebinarID, DateAndBeginningTime, Price FROM Webinars")
    webinars = cursor.fetchall()


    # 2. Wygenerowanie zamówień na dany webinar
    for (webinarid, webinar_date, price) in webinars:
        # Wygenerowanie ilości użytkowników
        users_quntity_for_webinar = random.randint(min_users_quantity_for_webinars, max_users_quantity_for_webinars)

        # Wybranie losowych użytkowników
        users_for_webinar = random.sample(users, users_quntity_for_webinar)

        # Wygenerować dane zamówienia
        for user in users_for_webinar:
            # Wygenerowanie daty zakópienia
            order_date = fake.date_time_between(start_date='-30d', end_date=webinar_date)

            # Dodanie zamówienia do bazy
            cursor.execute("""
                DECLARE @LastID INT;
                EXEC add_order @UserID = ?, @OrderDate = ?, @PaymentLink = ?, @LastID = @LastID OUTPUT;
                SELECT @LastID;                        
            """,
                user, order_date, f"https://example.com/{uuid.uuid4()}")

            # Odczytanie wartości OrderID
            orderid = cursor.fetchone()[0]

            # Dodać pod zamówienie do bazy
            cursor.execute("""
                EXEC add_suborder
                        @OrderID = ?,
                        @PaymentDeadline = ?,
                        @ExtendedPaymentDeadline = ?,
                        @PaymentDate = ?,
                        @FullPrice = ?,
                        @ProductID = ?,
                        @Payment = ?  
            """,
                orderid, 
                webinar_date, 
                None,
                order_date,
                price,
                webinarid,
                price
            )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie zamówień na WEBINARY do bazy")


    # 3. Pobranie ID kursów, data rozpoczęcia, cena i limit uczestników
    cursor.execute("SELECT distinct Courses.CourseID, StartDate, Price, Limit FROM Courses inner join Modules on Courses.CourseID = Modules.CourseID inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID")
    courses = cursor.fetchall()


    # 4. Wygenerowanie zamówień na dany kurs
    for (courseid, course_date, price, limit) in courses:
        # Wylosowanie ilości uczestników na danyc kurs
        if limit is None:
            users_quantity_for_course = random.randint(min_users_quantity_for_courses, max_users_quantity_for_courses)
        else:
            users_quantity_for_course = random.randint(10, limit)
        
        # Wybranie losowych użytkowników
        users_for_course = random.sample(users, users_quantity_for_course)


        # Wygenerowanie danych zamówienia
        for user in users_for_course:
            # Wygenerowanie daty zakópienia
            if course_date <= datetime.now().date():
                order_date = fake.date_time_between(start_date='-30d', end_date=course_date - timedelta(days=3))
            else:
                order_date = fake.date_time_between(start_date='-30d', end_date=datetime.now())
            
            # Dodanie zamówienia do bazy
            cursor.execute("""
                DECLARE @LastID INT;
                EXEC add_order @UserID = ?, @OrderDate = ?, @PaymentLink = ?, @LastID = @LastID OUTPUT;
                SELECT @LastID;                        
            """,
                user, order_date, f"https://example.com/{uuid.uuid4()}")
            
            # Odczytanie wartości OrderID
            orderid = cursor.fetchone()[0]

            # Dodać pod zamówienie do bazy
            cursor.execute("""
                EXEC add_suborder
                        @OrderID = ?,
                        @PaymentDeadline = ?,
                        @ExtendedPaymentDeadline = ?,
                        @PaymentDate = ?,
                        @FullPrice = ?,
                        @ProductID = ?,
                        @Payment = ?  
            """,
                orderid, 
                course_date - timedelta(days=3), 
                None,
                order_date,
                price,
                courseid,
                price
            )
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie zamówień na KURSY do bazy")
    


# TESTY
# Stworzenie stringu konfiguracyjnego do połączenia do bazy
# Załadowanie zmiennych środowiskowych
load_dotenv()

connection_string = ";".join([
    "DRIVER={ODBC Driver 17 for SQL Server}",
    f"SERVER={os.getenv('DB_SERVER')}",
    f"DATABASE={os.getenv('DB_DATABASE')}",
    f"UID={os.getenv('DB_USERNAME')}",
    f"PWD={os.getenv('DB_PASSWORD')}",
    "Encrypt=no",
    "CHARSET=UTF-8"
])

orders(connection_string, 25, 50, 25, 50)