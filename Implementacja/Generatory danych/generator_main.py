from dotenv import load_dotenv
import os
from Generators import users, webinars, courses

def main():
    # Załadowanie zmiennych środowiskowych
    load_dotenv()

    # Stworzenie stringu konfiguracyjnego do połączenia do bazy
    connection_string = ";".join([
        "DRIVER={ODBC Driver 17 for SQL Server}",
        f"SERVER={os.getenv('DB_SERVER')}",
        f"DATABASE={os.getenv('DB_DATABASE')}",
        f"UID={os.getenv('DB_USERNAME')}",
        f"PWD={os.getenv('DB_PASSWORD')}",
        "Encrypt=no",
        "CHARSET=UTF-8"
    ])

    # Wartości potrzebnych zmiennych

    # Kategoria USERS
    users_quantity = 50
    employees_quantity = 30
    webinars_coordinator_quantity = 5
    studies_coordinator_quantity = 5
    courses_coordinator_quantity = 5
    secretariat_quantity = 2
    lecturers_quantity = 12
    translators_quantity = 30
    how_many_languages_to_translators = 3 # ile maksymalnie języków może tłumaczyć jeden tłumacz

    # Kategoria WEBINARS
    webinars_quantity = 50
    plus_minus_days_for_webinars = 30 # ile dni wstecz i w przód mogą być dodane do daty rozpoczęcia webinaru
    start_hour_webinars = 8
    end_hour_webinars = 20

    # Kategoria COURSES
    courses_quantity = 50
    plus_minus_days_for_courses = 30 # ile dni wstecz i w przód mogą być dodane do daty rozpoczęcia kursu
    start_hour_courses = 8
    end_hour_courses = 20
    max_module_quantity_for_course = 10
    max_course_duration = 5 # ile czasu maksymalnie może trwać kurs

    # Kategoria STUDIES
    studies_quantity = 50
    max_quantity_subjects_in_study = 10
    min_quantity_subjects_in_study = 5
    practices_quantity = 50
    start_hour_studies = 8
    end_hour_studies = 20
    reunion_quantity = 7
    one_reunion_length = 3 # ile dni trwa jeden zjazd
    plus_minus_days_for_studies = 365 # ile dni wstecz i w przód mogą być dodane do daty rozpoczęcia studiów 
    semestr_quantity = 6


    # Wykonanie generatorów

    # 1. Generowanie USERS
    users.users(users_quantity, employees_quantity, webinars_coordinator_quantity, studies_coordinator_quantity, courses_coordinator_quantity, secretariat_quantity, lecturers_quantity, translators_quantity, how_many_languages_to_translators, connection_string)
    print()

    # 2. Generowanie WEBINARS
    webinars.webinars(webinars_quantity, plus_minus_days_for_webinars, start_hour_webinars, end_hour_webinars, connection_string)
    print()

    # 3. Generowanie COURSES
    courses.courses(courses_quantity, plus_minus_days_for_courses, start_hour_courses, end_hour_courses, max_module_quantity_for_course, max_course_duration, connection_string, webinars_quantity)
    print()

    # # 4. Generowanie STUDIES
    # studies.studies(studies_quantity, subject_quantity, max_quantity_subjects_in_study, min_quantity_subjects_in_study, practices_quantity, start_hour_studies, end_hour_studies, reunion_quantity, connection_string, courses_quantity, webinars_quantity, plus_minus_days_for_studies)


# Wykonanie funkcji main
if __name__ == "__main__":
    main()

