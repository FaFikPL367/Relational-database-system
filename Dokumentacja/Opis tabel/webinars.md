# Kategoria Webinars

## Tabela **Users_Webinars**
Zawiera informacje o tym, na jakie Webinary jest zapisany dany użytkownik:
- **UserID** [int] - identyfikator użytkownika
- **WebinarID** [int] - identyfikator webinaru

```SQL
CREATE TABLE Users_Webinars (
   UserID int  NOT NULL,
   WebinarID int  NOT NULL,
   CONSTRAINT Users_Webinars_pk PRIMARY KEY  (UserID,WebinarID)
);
```

## <hr>
## Tabela **Webinars**
---
Zawiera informacje o Webinarach:
- **WebinarID** [int] - identyfikator webinaru
- **Name** [nvarchar(30)] - nazwa webinaru
- **Description** [nvarchar(max)] - opis webinaru
- **Date** [date] - termin odbywania się  webinaru w formacie 'rok-miesiąc-dzień'
- **BeginningTime** [time(8)] - czas rozpoczęcia webinaru w formacie 'godzina:minuty:sekundy'
- **Duration** [time(8)] - czas trwania webinaru w formacie 'godziny:minuty:sekundy'
  - warunki: Duration > '00:00:00'
  - domyślna wartość: '01:30:00'
- **TeacherID** [int] - identyfikator prowadzącego dany webinar
- **TranslatorID** [int] - identyfikator tłumacza
- **Price** [money] - cena webinaru
  - warunki: Price >= 0
  - domyślna wartość: 0
- **LanguageID** [int] - identyfikator języka, w którym prowadzony jest webinar
- **RecordingLink** [nvarchar(100)] - link do nagrania z webinaru
- **MeetingLink** [nvarchar(100), unique] - link do webinaru

```SQL
CREATE TABLE Webinars (
   WebinarID int  NOT NULL,
   Name nvarchar(30)  NOT NULL,
   Description nvarchar(max)  NOT NULL,
   DateAndBeginningTime datetime  NOT NULL,
   Duration time(0)  NOT NULL DEFAULT '01:30:00' CHECK (Duration > '00:00:00'),
   CoordinatorID int  NOT NULL,
   TeacherID int  NOT NULL,
   TranslatorID int  NULL,
   Price money  NOT NULL DEFAULT 0 CHECK (Price >= 0),
   LanguageID int  NOT NULL,
   RecordingLink nvarchar(100)  NULL,
   MeetingLink nvarchar(100)  NOT NULL,
   CONSTRAINT WebinarMeetingLink UNIQUE (MeetingLink),
   CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);
```
