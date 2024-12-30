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