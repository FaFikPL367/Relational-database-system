create function check_classroom_availability(
    @Classroom int,
    @ModuleOrMeetingID int
) returns bit
as begin
    -- Domyślnie sala dostępna
    declare @Result bit = 0;

    declare @StartDate datetime = (select DateAndBeginningTime from Modules where ModuleID = @ModuleOrMeetingID union select DateAndBeginningTime from Meetings where MeetingID = @ModuleOrMeetingID)
    declare @EndDate datetime = dateadd(minute, datediff(minute, 0, (select Duration from Modules where ModuleID = @ModuleOrMeetingID union select Duration from Meetings where MeetingID = @ModuleOrMeetingID)), @StartDate)

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