# Kategoria Courses

## Tabela **Courses**
Zawiera informacje dotyczące kursów:
- **CourseID** [int] - klucz główny, identyfikator kursu
- **CoordinatorID** [int] - identyfikator koordynatora kursu
- **Name** [nvarchar(30)] - nazwa kursu
- **Description** [nvarchar(max)] - opis kursu
- **StartDate** [date] - data rozpoczęcia kursu w formacie 'rok-miesiąc-dzień'
- **EndDate** [date] - data zakończenia kursu w formacie 'rok-miesiąc-dzień'
- **Price** [money] - cena kursu
  - warunki: Price > 0
  - domyślna wartość: 100

```SQL
CREATE TABLE Courses (
   CourseID int  NOT NULL,
   CoordinatorID int  NOT NULL,
   Name nvarchar(30)  NOT NULL,
   Description nvarchar(max)  NOT NULL,
   StartDate date  NOT NULL,
   EndDate date  NOT NULL,
   Price money  NOT NULL DEFAULT 100 CHECK (Price > 0),
   CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);
```

## <hr>
## Tabela In-**person_Modules**
Zawiera informacje o modułach odbywających się stacjonarnie:
- **ModuleID** [int] - klucz główny, identyfikator modułu
- **Classroom** [int] - numer sali, w której odbywają się zajęcia
- **TransalatorID** [int] - identyfikator tłumacza
- **Limit** [int] - limit osób mogących uczestniczyć w danych zajęciach
  - waurnki: Limit > 0
  - domyślna wartość: 25

```SQL
CREATE TABLE In_person_Modules (
   ModuleID int  NOT NULL,
   Classroom int  NOT NULL,
   TranslatorID int  NULL,
   LanguageID int  NOT NULL,
   Limit int  NOT NULL DEFAULT 25 CHECK (Limit > 0),
   CONSTRAINT In_person_Modules_pk PRIMARY KEY  (ModuleID)
);
```

## <hr>
## Tabela **Modules**
Zawiera informacje dotyczące modułów:
- **ModuleID** [int] - klucz główny, identyfikator modułu
- **CourseID** [int] - identyfikator kursu, do którego należy dany moduł
- **Name** [nvarchar(50)] - nazwa modułu
- **Description** [nvarchar(max)] - opis modułu
- **TeacherID** [int] - identyfikator prowadzącego dany moduł
- **DateAndBeginningTime** [datetime] - data i czas rozpoczęcia modułu w formacie "rok:miesiąc:dzień godziny:minuty:sekundy"
- **Duration** [time(8)] - czas trwania modułu w formacie 'godziny:minuty:sekundy'
  - warunki: Duration > 0
  - domyślna wartość: '01:30:00'
- **TypeID** [int] - identyfikator typu modułu
```SQL
CREATE TABLE Modules (
   ModuleID int  NOT NULL IDENTITY(1, 1),
   TeacherID int  NOT NULL,
   CourseID int  NOT NULL,
   Name nvarchar(50)  NOT NULL,
   Description nvarchar(max)  NOT NULL,
   DateAndBeginningTime datetime  NOT NULL,
   Duration time(0)  NOT NULL DEFAULT '01:30:00' CHECK (Duration > '00:00:00'),
   TypeID int  NOT NULL,
   CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);
```
---

## <hr>
## Tabela **Types**
Zawiera informację o możliwych typach modułów czy spotkań:
- **TypeID** [int] - identyfikator typu 
- **TypeName** [varchar(20)] - nazwa typu, określająca sposób jego odbywania się (domyślna 'In-person'):
	- 'In-person' - stacjonarnie
	- 'Online Sync' - online synchronicznie
	- 'Online Async' - online asynchronicznie
	- 'Hybrid' - hybrydowo

```SQL
CREATE TABLE Types (
   TypeID int  NOT NULL IDENTITY(1, 1),
   TypeName varchar(20)  NOT NULL CHECK (TypeName IN ('In-person', 'Online Sync', 'Online Async', 'Hybrid')),
   CONSTRAINT TypeID PRIMARY KEY  (TypeID)
);
```

## <hr>
## Tabela **Online_Async_Modules**
Zawiera informacje o modułach odbywających się online asynchronicznie:
- **ModuleID** [int] - identyfikator modułu
- **RecordingLink** [nvarchar(100)] - link do nagrania

```SQL
CREATE TABLE Online_Async_Modules (
   ModuleID int  NOT NULL,
   RecordingLink nvarchar(100)  NOT NULL,
   CONSTRAINT OnliceAsyncModulesRecordingLInk UNIQUE (RecordingLink),
   CONSTRAINT Online_Async_Modules_pk PRIMARY KEY  (ModuleID)
);
```

## <hr>
## Tabela **Online_Sync_Modules**
Zawiera informacje o modułach odbywających się online synchronicznie:
- **ModuleID** [int] - identyfikator modułu
- **MeetingLink** [nvarchar(100), unique] - link do spotkania
- **RecordingLink** [nvarchar(100)] - link do nagrania ze spotkania
- **TranslatorID** [int] - identyfikator tłumacza
- **LanguageID** [int] - identyfikator języka

```SQL
CREATE TABLE Online_Sync_Modules (
   ModuleID int  NOT NULL,
   MeetingLink nvarchar(100)  NOT NULL,
   RecordingLink nvarchar(100)  NULL,
   TranslatorID int  NULL,
   LanguageID int  NOT NULL,
   CONSTRAINT OnlineSyncModulesMeetingLink UNIQUE (MeetingLink),
   CONSTRAINT Online_Sync_Modules_pk PRIMARY KEY  (ModuleID)
);
```

## <hr>
## Tabela **Users_Courses**
Zawiera informacje o tym, na jakie kursy jest zapisany dany użytkownik:
- **UserID** [int] - identyfikator użytkownika
- **CourseID** [int] - identyfikator kursu

```SQL
CREATE TABLE Users_Courses (
   UserID int  NOT NULL,
   CourseID int  NOT NULL,
   CONSTRAINT Users_Courses_pk PRIMARY KEY  (UserID,CourseID)
);
```

## <hr>
## Tabela **Users_Modules_Passes**
Zawiera informację o zaliczeniu poszczególnych modułów
przez danego użytkownika:
- **UserID** [int] - identyfikator użytkownika
- **ModuleID** [int] - identyfikator modułu
- **Passed** [bit] - informacja, czy moduł został zaliczony
przez danego użytkownika (1 - zaliczony, 0 - niezaliczony)

```SQL
CREATE TABLE Users_Modules_Passes (
   UserID int  NOT NULL,
   ModuleID int  NOT NULL,
   Passed bit  NULL,
   CONSTRAINT Users_Modules_Passes_pk PRIMARY KEY  (ModuleID,UserID)
);
```
