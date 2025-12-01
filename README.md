# Relational database system
---
This project presents a relational database system designed for a company offering a wide range of courses, webinars and training programs. The format of delivery is hybrid model combining both online and in-person activities.

The project indcludes ERD diagram, SQL schema, documentation for all procedures, views, functions and data generator.

## Goals of system
---
* Standarize data structures for multiple types of educational services
* Support hybrid, online, synchronous, asynchronous, and on-site delivery formats
* Store participant, enrollment, attendance, and payment information
* Manage schedules, modules, webinars, recordings, exams, and internships
* Manage schedules, modules, webinars, recordings, exams, and internships

## Types of educational services
---
### 1. Webinars
* Delivered live via a popular cloud webinar platform
* Recorded and made available to participants for **30 days**
* Recordings are not stored in the database — only external links or identifiers are saved
* Webinars can be **paid** or **free**
* Free webinars are publicly accessible; paid webinars require account + payment confirmation
* Webinars remain in the catalog indefinitely unless removed by an administrator

### 2. Courses (Short training programs)
Courses are paid-only and last several days. Complition requires passing at least **80%** of modules.

Modules types:
* **On-site (synchronous)** — includes assigned classroom, completed based on attendance
* **On-site (synchronous)** — includes assigned classroom, completed based on attendance
* **Online asynchronous** — completed by watching required materials (automated verification)
* **Online asynchronous** — completed by watching required materials (automated verification)

### 3. Studies (Multi-year academic-like programs)
Multi-semester programs combining online and on-site classes.

Key characteristics:
* Require syllabus (program) defined before start; no thematic modifications allowed
* Semester schedule must be published in advance, but may be adjusted for exceptional reasons
* Mandatory attendance: 80% of classes, with possibility to make up missed classes via similar commercial courses
* Include internships, twice per year, minimum 14 days, with 100% attendance required
* End with a final exam
* Classes can be on-site, online, or hybrid
* External participants may join single study sessions without enrolling in the full program; pricing differs for outsiders


## Payment system interaction
---
The system integrates with an external payment provider responsible for handling all financial transaction. The internal database **does not process or store payment card retails** an relies on status information returned by the payment provider.

* User can add multiple products (webinars, courses, studies) to shopping cart (cart is not implemented as part of database). Base on cart the system generates order with details in database.
* Access rules based on payment completion:
  * **Webinars** - access is granted only after successful payment
  * **Courses** - enrollment requires an initial deposit and full payment must be completed at least 3 days before the course start
  * **Studies** - enrollment requires an entry fee and each study sesstion must be paid no later than 3 days before it begins
* The School Director may grant payment exceptions. Such exceptions are recorded in the system for auditing purpose.

## Reporting (Views)
The system provides a set of predefined database views for supproting used reporting scenerios. Some of example views:
* Views for presenting attendance statistics for all past events
* Views for attendance list per-event
* Views for teachers and translators schedule
* Views for extended payments
* and many additional analytical views designed to simplify administrative reporting


## Example data generator
---
To run data generator, the following Python packages are required:
```
python-dotenv
pyodbc
faker
```

To run Python scripts first you need to preapare ".env" file that contains database connection settings:
```bash
cp .env.example .env
rm .env.example
```

## ERD diagram
---
![ERD diagram](Dokumentacja/Opis%20dodatkowych%20rzeczy//schemat_bazy_danych.png)

## Project structure
---
```
/Dokumentacja
    /Opis dodatkowych rzeczy
        funkcje-uzytkownicy.md      # description of system user roles
        opis_generowania_danych.md  # description of how sample data was generated
        schemat_bazy_danych.png     # ERD diagram
    
    /Opis implementacji
        funkcje.md                  # description of database functions
        indeksy.md                  # description of database indexes
        procedury.md                # description of stored procedures
        triggery.md                 # description of triggers
        uprawnienia.md              # description of user privileges
        widoki.md                   # description of database views

    /Opis tabel
        courses.md                  # description of the COURSES table
        orders.md                   # description of the ORDERS table
        studies.md                  # description of the STUDIES table
        users.md                    # description of the USERS table
        webinars.md                 # description of the WEBINARS table

/Implementacja
    /Funkcje                        # SQL code for functions
    /Indeksy                        # SQL code for indexes
    /Procedury                      # SQL code for stored procedures
    /Triggery                       # SQL code for triggers
    /Widoki                         # SQL code for views
    /Generatory danych              # Python scripts for generating test data
```

## Technologies used
* Microsoft SQL Server
* SQL
* Python - for example data generator (with faker library)
* DataGrip - for testing and writing SQL
* Vertabelo - preparation of ERD diagram and database models


