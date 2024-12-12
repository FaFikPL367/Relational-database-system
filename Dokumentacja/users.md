# Kategoria Users
---

## Tabela **Users**
Zawiera ona informacje o użytkownikach:
 * **UserID** [int] - klucz główny, identyfikator użytkownika
 * **FirstName** [nvarchar(50)] - imię użytkownika
 * **LastName** [nvarchar(50)] - nazwisko użytkownika
 * **Phone** [varchar(15), unique] - numer telefonu użytkownika 
    * warunki: LEN(Phone) = 15 AND ISNUMERIC(Phone) = 1
 * **Email** [nvarchar(50), unique] - email użytkownika
    * warunki: Email LIKE '%_@%.%'
 * **Address** [nvarchar(50)] - adres użytkownika
 * **City** [nvarchar(30)] - miasto użytkownika
 * **PostalCode** [varcahr(10)] - kod pocztowy użytkownika
``` SQL
CREATE TABLE Users (
   UserID int  NOT NULL,
   FirstName nvarchar(50)  NOT NULL,
   LastName nvarchar(50)  NOT NULL,
   Phone varchar(15)  NOT NULL CHECK (LEN(Phone) = 15 and ISNUMERIC(Phone) = 1),
   Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
   Address nvarchar(50)  NOT NULL,
   City nvarchar(30)  NOT NULL,
   PostalCode varchar(10)  NOT NULL,
   CONSTRAINT UserPhone UNIQUE (Phone),
   CONSTRAINT UserEmail UNIQUE (Email),
   CONSTRAINT UserID PRIMARY KEY  (UserID)
);
```

## <hr>
## Tabela **Employees**
Zawiera informacje o pracownikach:
 * **EmployeeID** [int] - klucz główny, identyfikator pracownika
 * **FirstName** [nvarchar(50)] - imię pracownika
 * **LastName** [nvarchar(50)] - nazwisko pracownika
 * **Phone** [varcahr(15), unique] - numer telefonu pracownika
    * warunki: LEN(Phone) = 15 AND ISNUMERIC(Phone) = 1
 * **Email** [nvarchar(50), unique] - email pracownika
    * warunki: Email LIKE '%_@%.%'
 * **Address** [nvarchar(50)] - adres pracownika
 * **City** [nvarchar(30)] - miasto pracownika
 * **PostalCode** [varchar(10)] - kod pocztowy pracownika
 * **PositionID** [int] - identyfikator pozycji pracownika
```SQL
CREATE TABLE Employees (
   EmployeeID int  NOT NULL,
   FirstName nvarchar(50)  NOT NULL,
   LastName nvarchar(50)  NOT NULL,
   Phone varchar(15)  NOT NULL CHECK (LEN(Phone) = 15 and ISNUMERIC(Phone) = 1),
   Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
   Address nvarchar(50)  NOT NULL,
   City nvarchar(30)  NOT NULL,
   PostalCode varchar(10)  NOT NULL,
   PositionID int  NOT NULL,
   CONSTRAINT EmployeePhone UNIQUE (Phone),
   CONSTRAINT EmployeeEmail UNIQUE (Email),
   CONSTRAINT Employees_pk PRIMARY KEY  (EmployeeID)
);
```

## <hr>
## Tabela **Employees_Positions**
Zawiera informacje o możliwych pozycjach pracowników:
 * **PositionID** [int] - klucz główny, identyfikator pozycji
 * **PositionName** [nvarchar(30)] - nazwa pozycji
```SQL
CREATE TABLE Employees_Postions (
   PositionID int  NOT NULL,
   PositionName nvarchar(30)  NOT NULL,
   CONSTRAINT Employees_Postions_pk PRIMARY KEY  (PositionID)
);
```

## Tabela **Translators**
Zwiera informacje o tłumaczach:
 * **TranslatorID** [int] - klucz główny, identyfikator tłumacza
 * **FirstName** [nvarchar(50)] - imię tłumacza
 * **LastName** [nvarchar(50)] - nazwisko tłumacza
 * **Phone** [varchar(15), unique] - numer telefonu tłumacza
    * warunki: LEN(Phone) = 15 AND ISNUMERIC(Phone) = 1
 * **Email** [nvarchar(50), unique] - email tłumacza
    * warunki: Email LIKE '%_@%.%'
 * **Address** [nvarchar(50)] - adres tłumacza
 * **City** [nvarchar(30)] - miasto tłumacza
 * **PostalCode** [varchar(10)] - kod pocztowy tłumacza
```SQL
CREATE TABLE Translators (
   TranslatorID int  NOT NULL,
   FirstName nvarchar(50)  NOT NULL,
   LastName nvarchar(50)  NOT NULL,
   Phone varchar(15)  NOT NULL CHECK (LEN(Phone) = 15 and ISNUMERIC(Phone) = 1),
   Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
   Address nvarchar(50)  NOT NULL,
   City nvarchar(30)  NOT NULL,
   PostalCode varchar(10)  NOT NULL,
   CONSTRAINT TranslatorPhone UNIQUE (Phone),
   CONSTRAINT TranslatorEmail UNIQUE (Email),
   CONSTRAINT UserID PRIMARY KEY  (TranslatorID)
);
```

## <hr>
## Tabela **Translator_Languages**
Zawiera informajce o językach jakimi posługują się tłumacze:
 * **TranslatorID** [int] - część klucza głównego, identyfikator tłumacza
 * **LanguageID** [int] - klucz obcy, identyfikator języka
```SQL
CREATE TABLE Translators_Languages (
   TranslatorID int  NOT NULL,
   LanguageID int  NOT NULL,
   CONSTRAINT Translators_Languages_pk PRIMARY KEY  (TranslatorID)
);
```

## <hr>
## Tabela **Languages**
Zawiera możliwe języki tłumaczenia:
 * **LanguageID** [int] - klucz główny, identyfikator języka
 * **LanguaneName** [nvarchar(30)] - nazwa języka
```SQL
CREATE TABLE Languages (
   LanguageID int  NOT NULL,
   LanguageName nvarchar(30)  NOT NULL,
   CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);
```