create view users_activities_collisions as
with CombinedActivities as (
    select
        UserID,
        ModuleID as ActivityID,
        DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) as DateAndEndingTime,
        'Module' as ActivityType
    from Modules m
    join Users_Courses uc on m.CourseID = uc.CourseID

    union all

    select
        UserID,
        meet.MeetingID as ActivityID,
        DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) as DateAndEndingTime,
        'Meeting' as ActivityType
    from Meetings meet
    join Users_Meetings_Attendance meeta on meet.MeetingID = meeta.MeetingID

    union all

    select
        UserID,
        w.WebinarID as ActivityID,
        DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, Duration), DateAndBeginningTime) as DateAndEndingTime,
        'Webinar' as ActivityType
    from Webinars w
    join Users_Webinars uw on w.WebinarID = uw.WebinarID
),
Collisions as (
    select
        a.UserID,
        a.ActivityID as Activity1ID,
        a.ActivityType as Activity1Type,
        a.DateAndBeginningTime as StartTime1,
        a.DateAndEndingTime as EndTime1,
        b.ActivityID as Activity2ID,
        b.ActivityType as Activity2Type,
        b.DateAndBeginningTime as StartTime2,
        b.DateAndEndingTime as EndTime2
    from CombinedActivities a
    join CombinedActivities b on a.UserID = b.UserID and a.ActivityID < b.ActivityID
    where
       (a.DateAndBeginningTime between b.DateAndBeginningTime and b.DateAndEndingTime) or
       (a.DateAndEndingTime between b.DateAndBeginningTime and b.DateAndEndingTime) or
       (b.DateAndBeginningTime between a.DateAndBeginningTime and a.DateAndEndingTime) or
       (b.DateAndEndingTime between a.DateAndBeginningTime and a.DateAndEndingTime)
)
select * from Collisions
order by UserID;
