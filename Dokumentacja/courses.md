# Kategoria Courses
---

## Courses
---
Zawiera informacje dotyczące kursów:
- CourseID [int] - klucz główny, identyfikator kursu
- CoordinatorID [int] - identyfikator koordynatora kursu
- Name [nvarchar(30)] - nazwa kursu
- Description [ntext] - opis kursu
- StartDate [date] - data rozpoczęcia kursu
- EndDate [date] - data zakończenia kursu
- Price [money] - cena kursu

```
CREATE TABLE Courses (
   CourseID int  NOT NULL,
   CoordinatorID int  NOT NULL,
   Name nvarchar(30)  NOT NULL,
   Description ntext  NOT NULL,
   StartDate date  NOT NULL,
   EndDate date  NOT NULL CHECK (EndDate > StartDate),
   Price money  NOT NULL DEFAULT 100 CHECK (Price > 0),
   CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);
```
---

## In-person_Modules
---
Zawiera informacje o modułach odbywających się stacjonarnie:
- ModuleID [int] - klucz główny, identyfikator modułu
- Faculty [nvarchar(10)] - nazwa wydziału, w którego budynku odbywają się zajęcia
- Classroom [int] - numer sali, w której odbywają się zajęcia
- TransalatorID [int] - identyfikator tłumacza
- Limit [int] - limit osób mogących uczestniczyć w danych zajęciach

```
CREATE TABLE In-person_Modules (
   ModuleID int  NOT NULL,
   Faculty nvarchar(10)  NOT NULL,
   Classroom int  NOT NULL,
   TranslatorID int  NULL,
   Limit int  NOT NULL,
   CONSTRAINT In-person_Modules_pk PRIMARY KEY  (ModuleID)
);
```
---

## Modules
---
Zawiera informacje dotyczące modułów:
- ModuleID [int] - klucz główny, identyfikator modułu
- CourseID [int] - identyfikator kursu, do którego należy dany moduł
- Name [nvarchar(50)] - nazwa modułu
- Description [ntext] - opis modułu
- TeacherID [int] - identyfikator prowadzącego dany moduł
- TypeID [int] - identyfikator typu modułu

```
CREATE TABLE Modules (
   ModuleID int  NOT NULL,
   CourseID int  NOT NULL,
   Name nvarchar(50)  NOT NULL,
   Description ntext  NOT NULL,
   TeacherID int  NOT NULL,
   TypeID int  NOT NULL,
   CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);
```
---

## Modules Types
---
Zawiera informację o typie danego modułu:
- TypeID [int] - identyfikator typu modułu
- TypeName [varchar(20)] - nazwa typu modułu

```
CREATE TABLE Modules_Types (
   TypeID int  NOT NULL,
   TypeName varchar(20)  NOT NULL DEFAULT 'In-person' CHECK (TypeName IN ('In-person', 'Online Sync', 'Online Async', 'Hybrid')),
   CONSTRAINT TypeID PRIMARY KEY  (TypeID)
);
```
---

## Online_Async_Modules
---
Zawiera informacje o modułach odbywających się online asynchronicznie:
- ModuleID [int] - identyfikator modułu
- RecordingLink [nvarchar(100)] - link do nagrania

```
CREATE TABLE Online_Async_Modules (
   ModuleID int  NOT NULL,
   RecordingLink nvarchar(100)  NOT NULL,
   CONSTRAINT Online_Async_Modules_pk PRIMARY KEY  (ModuleID)
);
```
---

## Online_Sync_Modules
---
Zawiera informacje o modułach odbywających się online synchronicznie:
- ModuleID [int] - identyfikator modułu
- MeetingLink [nvarchar(100)] - link do spotkania
- RecordingLink [nvarchar(100)] - link do nagrania ze spotkania
- TranslatorID [int] - identyfikator tłumacza

```
CREATE TABLE Online_Sync_Modules (
   ModuleID int  NOT NULL,
   MeetingLink nvarchar(100)  NOT NULL,
   RecordingLink nvarchar(100)  NOT NULL,
   TranslatorID int  NULL,
   CONSTRAINT Online_Sync_Modules_pk PRIMARY KEY  (ModuleID)
);
```
---

## Users_Courses
---
Zawiera informację o tym, na jakie kursy jest zapisany dany użytkownik
- UserID [int] - identyfikator użytkownika
- CourseID [int] - identyfikator kursu

```
CREATE TABLE Users_Courses (
   UserID int  NOT NULL,
   CourseID int  NOT NULL,
   CONSTRAINT Users_Courses_pk PRIMARY KEY  (UserID,CourseID)
);
```
---

## Users_Modules_Passes
---
Zawiera informację o zaliczeniu poszczególnych modułów
przez danego użytkownika
- UserID [int] - identyfikator użytkownika
- CourseID [int] - identyfikator kursu, do którego należy dany moduł
- ModuleID [int] - identyfikator modułu
- Passed [bit] - informacja, czy moduł został zaliczony przez danego użytkownika

```
CREATE TABLE Users_Modules_Passes (
   UserID int  NOT NULL,
   CourseID int  NOT NULL,
   ModuleID int  NOT NULL,
   Passed bit  NOT NULL,
   CONSTRAINT UserID PRIMARY KEY  (ModuleID,UserID,CourseID)
);
```
