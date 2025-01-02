## Funkcje
---
### Check_translator_language
Funkcja dostaje parę indeksów, język i tłumacz, a następnie sprawdza czy dany tłumacz zna podany język.
```SQL
create function check_translator_language(
    @TranslatorID int,
    @LanguageID int
)
returns bit
as begin
    declare @Result bit;

    -- Sprawdzenie czy dana para istnieje
    if exists(select 1 from Translators_Languages where TranslatorID = @TranslatorID and
                                                        LanguageID = @LanguageID)
    begin
        set @Result = 1;
    end

    else if @TranslatorID is null and @LanguageID = 19
    begin
        set @Result = 1;
    end
    else
    begin
        set @Result = 0;
    end

    return @Result;
end
```

---

### Check_translator_availability
Funkcja dostaje ID tłumacza, datę i czas rozpoczęcia zajęć oraz czas trawania zajęć. Jej celem jest sprawdzenie czy podany tłumacz ma inne zajęcia w tym czasie. Sprawdzane są wszystkie jego możliwe aktywności (webinary, spotkania studyjne, moduły).
```SQL
create function check_translator_availability(
    @TranslatorID int,
    @DateAndBeginningTime datetime,
    @Duration time(0)
) returns bit
as begin
    declare @Result bit = 0;

    declare @StartDate datetime = @DateAndBeginningTime;
    declare @EndDate datetime = dateadd(minute, datediff(minute, 0, @Duration), @DateAndBeginningTime);

    -- Zadekalrowanie tabeli ze wszystkimi spotkaniami tłumacza
    declare @TranslatorActivities table (
        DateAndBeginningTime datetime,
        Duration time(0)
                                        );
    
    -- Moduły stacjonarne
    insert @TranslatorActivities
    select DateAndBeginningTime, Duration
    from In_person_Modules inner join Modules on In_person_Modules.ModuleID = Modules.ModuleID
    where TranslatorID = @TranslatorID;

    -- Moduły synchroniczne
    insert @TranslatorActivities
    select DateAndBeginningTime, Duration
    from Online_Sync_Modules inner join Modules on Online_Sync_Modules.ModuleID = Modules.ModuleID
    where TranslatorID = @TranslatorID;

    -- Spotkania stacjonarne
    insert @TranslatorActivities
    select DateAndBeginningTime, Duration
    from In_person_Meetings inner join Meetings on In_person_Meetings.MeetingID = Meetings.MeetingID
    where TranslatorID = @TranslatorID;

    -- Spotkania synchronoczne
    insert @TranslatorActivities
    select DateAndBeginningTime, Duration
    from Online_Sync_Meetings inner join Meetings on Online_Sync_Meetings.MeetingID = Meetings.MeetingID
    where TranslatorID = @TranslatorID;

    -- Sprawdzenie czy date się nie nakładają
    if exists(select 1 from @TranslatorActivities where (
        @StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        (@StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) and
         @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime)) or
        (DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    return @Result;
end
```

---

### Check_teachers_availability
Funkcja otrzymuje ID nauczyciela, datę i czas rozpoczęcia zajęć oraz czas ich trwania. Jej celem jest sprawdzenei czy dany nauczyciel nie ma w tym czasie innych aktywności (spotkania stydujne, webinary, moduły).
```SQL
create function check_teachers_availability(
    @TeacherID int,
    @DateAndBeginningTime datetime,
    @Duration time(0)
) returns bit
as begin
    declare @Result bit = 0;

    declare @StartDate datetime;
    declare @EndDate datetime;
    set @StartDate = @DateAndBeginningTime
    set @EndDate = dateadd(minute, datediff(minute, 0, @Duration), @DateAndBeginningTime);

    -- Sprawdzenie czy nie ma w tym czasie żadnego spotkania studyjnego
    if exists(select 1 from Meetings where Meetings.TeacherID = @TeacherID and (
        @StartDate between Meetings.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Meetings.Duration), Meetings.DateAndBeginningTime) or
        @EndDate between Meetings.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Meetings.Duration), Meetings.DateAndBeginningTime) or
        (@StartDate between Meetings.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Meetings.Duration), Meetings.DateAndBeginningTime) and
         @EndDate between Meetings.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Meetings.Duration), Meetings.DateAndBeginningTime)) or
        (Meetings.DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Meetings.Duration), Meetings.DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    -- Sprawdzenie czy nie ma w tym czasie żadnego webinaru
    if exists(select 1 from Webinars where Webinars.TeacherID = @TeacherID and (
        @StartDate between Webinars.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Webinars.Duration), Webinars.DateAndBeginningTime) or
        @EndDate between Webinars.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Webinars.Duration), Webinars.DateAndBeginningTime) or
        (@StartDate between Webinars.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Webinars.Duration), Webinars.DateAndBeginningTime) and
         @EndDate between Webinars.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Webinars.Duration), Webinars.DateAndBeginningTime)) or
         (Webinars.DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Webinars.Duration), Webinars.DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    -- Sprawdzenie czy nie ma w tym czasie żadnego modułu
    if exists(select 1 from Modules where Modules.TeacherID = @TeacherID and (
        @StartDate between Modules.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Modules.Duration), Modules.DateAndBeginningTime) or
        @EndDate between Modules.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Modules.Duration), Modules.DateAndBeginningTime) or
        (@StartDate between Modules.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Modules.Duration), Modules.DateAndBeginningTime) and
         @EndDate between Modules.DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Modules.Duration), Modules.DateAndBeginningTime)) or
         (Modules.DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Modules.Duration), Modules.DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    return @Result;
end
```

---

### Check_classroom_availability
Funkcja dostaje numer klasy oraz ID modułu. Jej celem jest sprawdzenie czy podany moduł może się odbyć w tej sali na podstawie czasu rozpoczęcia danego modułu.
```SQL
create function check_classroom_availability(
    @Classroom int,
    @ModuleID int
) returns bit
as begin
    -- Domyślnie sala dostępna
    declare @Result bit = 0;

    declare @StartDate datetime = (select DateAndBeginningTime from Modules where ModuleID = @ModuleID)
    declare @EndDate datetime = dateadd(minute, datediff(minute, 0, (select Duration from Modules where ModuleID = @ModuleID)), @StartDate)

    -- Pobranie danych o czasie danego modułu dla danej sali
    declare @tmpInPersonModules table (
        ModuleID int,
        DateAndBeginningTime datetime,
        Duration time(0)
                                      );

    insert @tmpInPersonModules
    select In_person_Modules.ModuleID, DateAndBeginningTime, Duration
    from In_person_Modules inner join Modules on In_person_Modules.ModuleID = Modules.ModuleID
    where Classroom = @Classroom

    -- Sprawdzenie czy w danym okresie nie ma żadnego modułu w danej sali
    if exists(select 1 from @tmpInPersonModules where (
        @StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        (@StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) and
         @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime)) or
        (DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    -- Pobranie danych o czasie danego spotkania w danej sali
    declare @tmpInPersonMettings table (
        MettingID int,
        DateAndBeginningTime datetime,
        Duration time(0)
                                      );

    insert @tmpInPersonMettings
    select In_person_Meetings.MeetingID, DateAndBeginningTime, Duration
    from In_person_Meetings inner join Meetings on In_person_Meetings.MeetingID = Meetings.MeetingID
    where Classroom = @Classroom

    -- Sprawdzenie czy w danym okresie nie ma żadnego spotkania studyjnego w danej sali
    if exists(select 1 from @tmpInPersonMettings where (
        @StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) or
        (@StartDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) and
         @EndDate between DateAndBeginningTime and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime)) or
        (DateAndBeginningTime between @StartDate and @EndDate and dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) between @StartDate and @EndDate)
        ))
    begin
        set @Result = 1;
    end

    return @Result;
end
```