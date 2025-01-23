from faker import Faker
import pyodbc, random, uuid, os
from datetime import datetime, timedelta
from dotenv import load_dotenv


# Dla poprawności danych (NIE ZMIENIAĆ !!!)
Faker.seed(0)
random.seed(65)


# Inicjalizajca Faker'a
fake = Faker('pl_PL')


def orders(connection_string, min_users_quantity_for_webinars, max_users_quantity_for_webinars, min_users_quantity_for_courses, max_users_quantity_for_courses, min_users_quantity_for_studies, max_users_quantity_for_studies):
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
            if webinar_date <= datetime.now():
                order_date = fake.date_time_between(start_date='-30d', end_date=webinar_date)
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
    cursor.execute("SELECT distinct Courses.CourseID, StartDate, Price, min(Limit) FROM Courses inner join Modules on Courses.CourseID = Modules.CourseID inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID group by Courses.CourseID, StartDate, Price")
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
            # Wygenerowanie daty zakupienia
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


    # 5. Pobranie ID studiów, data rozpoczęcia, cena i limit uczestników
    cursor.execute("SELECT distinct Studies.StudiesID, Studies.StartDate, Studies.Price, min(Limit ) FROM Studies inner join Studies_Reunion on Studies.StudiesID = Studies_Reunion.StudiesID inner join Meetings on Studies_Reunion.ReunionID = Meetings.ReunionID inner join In_person_Meetings on Meetings.MeetingID = In_person_Meetings.MeetingID group by Studies.StudiesID, Studies.StartDate, Studies.Price")
    studies = cursor.fetchall()


    # 6. Wygenerowanie zamówień na dane studia
    for (studiesid, studies_date, price, limit) in studies:
        # Wylosowanie ilości uczestników na danyc kurs
        if limit is None:
            users_quantity_for_studies = random.randint(min_users_quantity_for_studies, max_users_quantity_for_studies)
        else:
            users_quantity_for_studies = random.randint(10, limit)
        
        # Wybranie losowych użytkowników
        users_for_studies = random.sample(users, users_quantity_for_studies)

        # Wygenerowanie danych zamówienia
        for user in users_for_studies:
            # Wygenerowanie daty zakupienia
            if studies_date <= datetime.now().date():
                order_date = fake.date_time_between(start_date='-30d', end_date=studies_date - timedelta(days=15))
            else:
                order_date = fake.date_time_between(start_date='-30d', end_date=datetime.now())
            
            # Dodanie zamówień do bazy
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
                studies_date - timedelta(days=15), 
                None,
                order_date,
                price,
                studiesid,
                price
            )
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie zamówień na STUDIA do bazy")

    ############################################
    # Modyfikacja wpisancyh danych

    # 1. Ustawienie kilku zamówień z przedłużoną datą płatności
    cursor.execute("SELECT SubOrderID, PaymentDeadline FROM Orders_Details")
    suborders = cursor.fetchall()
    suborders_quantity = len(suborders)

    # Wybranie zamówień do przedłużenia
    suborders_to_extend = random.sample(suborders, int(suborders_quantity * 0.05))

    for (suborder_id, payment_deadline) in suborders_to_extend:
        # Wykonanie zmiany daty 
        cursor.execute(
            """
            EXEC set_extended_payment_deadline
                @SubOrderID = ?,
                @ExtendedPaymentDeadline = ?
            """,
            suborder_id,
            payment_deadline + timedelta(days=7)
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie przedłużenia terminu płatności do bazy")


    # 2. Ustawienie kliku wpisów tak aby oznaczały zapłatę po terminie
    suborders_to_late_payment = random.sample(suborders, int(suborders_quantity * 0.1))

    for (suborder_id, payment_deadline) in suborders_to_late_payment:
        # Wylosowanie ilości dni opóźnienia
        days_of_delay = random.randint(1, 15)

        if payment_deadline + timedelta(days=days_of_delay) <= datetime.now().date():
            # Wykonanie zmiany daty zapłąty
            cursor.execute(
                """
                    update Orders_Details
                    set PaymentDate = DATEADD(day, ?, PaymentDeadline)
                    where SubOrderID = ?
                """,
                days_of_delay,
                suborder_id
            )
        else:
            # Założenie, że osoba spóźni się z zapłatą
            cursor.execute(
                """
                    update Orders_Details
                    set PaymentDate = ?
                    where SuborderID = ?
                """,
                None, 
                suborder_id
            )
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie opóźnienia w zapłacie do bazy")


    # 3. Ustawienia zdania modułów w kursach dla modułów zakończonych
    cursor.execute("SELECT UserID, ModuleID FROM Users_Modules_Passes")
    users_modules_passes = cursor.fetchall()

    # Dla każdego wpisu decydujemy czy zdał czy nie
    for (userid, moduleid) in users_modules_passes:
        # Sprawdzamy jeszcze czy dany moduł się odbył
        cursor.execute("SELECT ModuleID FROM Modules where ModuleID = ? and DateAndBeginningTime < ?", moduleid, datetime.now())
        if cursor.fetchone() is not None:
            # Wylosowanie czy zdał czy nie
            passed = random.choice([True, False, True, True, True, True])

            # Dodanie wpisu do bazy
            cursor.execute(
                """
                    update Users_Modules_Passes
                    set Passed = ?
                    where UserID = ? and ModuleID = ?
                """,
                userid, moduleid, passed
            )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie zdań modułów do bazy")


    # 4. Ustawienie obecności na spotkaniach studyjnych
    cursor.execute("SELECT UserID, MeetingID FROM Users_Meetings_Attendance")
    users_meetings_presence = cursor.fetchall()

    # Dla każdego wpisu decydujemy czy był czy nie
    for (userid, meetingid) in users_meetings_presence:
        # Sprawdzamy jeszcze czy dane spotkanie się odbyło
        cursor.execute("SELECT MeetingID FROM Meetings where MeetingID = ? and DateAndBeginningTime < ?", meetingid, datetime.now())
        if cursor.fetchone() is not None:
            # Wylosowanie czy był czy nie
            present = random.choice([True, False, True, True, True, True])

            # Dodanie wpisu do bazy
            cursor.execute(
                """
                    update Users_Meetings_Attendance
                    set Present = ?
                    where UserID = ? and MeetingID = ?
                """,
                present, userid, meetingid
            )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie obecności na spotkaniach do bazy")


    # 5. Ustawienie ocen dla studentów
    cursor.execute("select UserID, StudiesID from Users_Studies")
    users_studies = cursor.fetchall()

    users_studies_sample = random.sample(users_studies, int(len(users_studies) * 0.1))

    # Dla każdego decydujemy czy ustawiamy jakąś ocenę
    for (userid, studiesid) in users_studies_sample:
        # Wykonujemy aktualizację oceny
        cursor.execute(
            """
                update Users_Studies
                set Grade = ?
                where UserID = ? and StudiesID = ?
            """,
            random.randint(2, 5), userid, studiesid
        )
    
    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie ocen do bazy")


    # 6. Przypisanie jakiś praktyk do studentów
    cursor.execute("select PracticeID from Practices")
    practices = cursor.fetchall()
    practices = [practice[0] for practice in practices]

    users_studies_sample = random.sample(users_studies, int(len(users_studies) * 0.1))

    # Dla każdego decydujemy czy odbył praktyki czy nie
    for (userid, studiesid) in users_studies_sample:
        # Wylosowanie czy odbył praktyki czy nie
        if random.choice([True, False, True, True, True, True, True, True, True, True]):
            # Wybranie praktyki
            practiceid = random.choice(practices)

            # Dodanie wpisu do bazy
            cursor.execute(
                """
                    insert into Users_Practices_Attendance (UserID, StudiesID, PracticeID, Present)
                    values (?, ?, ?, ?)
                """,
                userid, studiesid, practiceid, True
            )

    # Zatwierdzenie zmian
    conn.commit()
    print("Pomyślne dodanie praktyk do bazy")
        
