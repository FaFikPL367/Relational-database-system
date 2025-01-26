create view teachers_and_translators_schedule as
    select
        e1.EmployeeID,
        e1.FirstName,
        e1.LastName,
        'Teacher' as EmployeeType,
        case
            when meet1.MeetingID in (select MeetingID from In_person_Meetings) then 'InPersonMeeting'
            when meet1.MeetingID in (select MeetingID from Online_Sync_Meetings) then 'OnlineSyncMeeting'
            else 'OnlineAsyncMeeting'
        end as TypeOfActivity,
        meet1.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, meet1.Duration), meet1.DateAndBeginningTime) as DateAndEndingTime
    from Employees e1
    join Meetings meet1 on e1.EmployeeID = meet1.TeacherID
    where meet1.DateAndBeginningTime > getdate()

    union all

    select
        e2.EmployeeID,
        e2.FirstName,
        e2.LastName,
        'Teacher' as EmployeeType,
        'Webinar' as TypeOfActivity,
        w1.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, w1.Duration), w1.DateAndBeginningTime) as DateAndEndingTime
    from Employees e2
    join Webinars w1 on e2.EmployeeID = w1.TeacherID
    where w1.DateAndBeginningTime > getdate()

    union all

    select
        e3.EmployeeID,
        e3.FirstName,
        e3.LastName,
        'Teacher' as EmployeeType,
        case
            when mod1.ModuleID in (select ModuleID from In_person_Modules) then 'InPersonModule'
            when mod1.ModuleID in (select ModuleID from Online_Sync_Modules) then 'OnlineSyncModule'
            else 'OnlineAsyncModule'
        end as TypeOfActivity,
        mod1.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, mod1.Duration), mod1.DateAndBeginningTime) as DateAndEndingTime
    from Employees e3
    join Modules mod1 on e3.EmployeeID = mod1.TeacherID
    where mod1.DateAndBeginningTime > getdate()

    union all

    select
        t1.TranslatorID,
        t1.FirstName,
        t1.LastName,
        'Translator' as EmployeeType,
        'InPersonMeeting' as TypeOfActivity,
        im1.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, im1.Duration), im1.DateAndBeginningTime) as DateAndEndingTime
    from Translators t1
    join In_person_Meetings im1 on t1.TranslatorID = im1.TranslatorID
    join Meetings meet2 on im1.MeetingID = meet2.MeetingID
    where meet2.DateAndBeginningTime > getdate()

    union all

    select
        t2.TranslatorID,
        t2.FirstName,
        t2.LastName,
        'Translator' as EmployeeType,
        'OnlineSyncMeeting' as TypeOfActivity,
        om_meeting.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, om_meeting.Duration), om_meeting.DateAndBeginningTime) as DateAndEndingTime
    from Translators t2
    join Online_Sync_Meetings om_meeting on t2.TranslatorID = om_meeting.TranslatorID
    join Meetings meet3 on om_meeting.MeetingID = meet3.MeetingID
    where meet3.DateAndBeginningTime > getdate()

    union all

    select
        t3.TranslatorID,
        t3.FirstName,
        t3.LastName,
        'Translator' as EmployeeType,
        'Webinar' as TypeOfActivity,
        w2.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, w2.Duration), w2.DateAndBeginningTime) as DateAndEndingTime
    from Translators t3
    join Webinars w2 on t3.TranslatorID = w2.TranslatorID
    where w2.DateAndBeginningTime > getdate()

    union all

    select
        t4.TranslatorID,
        t4.FirstName,
        t4.LastName,
        'Translator' as EmployeeType,
        'InPersonModule' as TypeOfActivity,
        im2.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, im2.Duration), im2.DateAndBeginningTime) as DateAndEndingTime
    from Translators t4
    join In_person_Modules im2 on t4.TranslatorID = im2.TranslatorID
    join Modules mod2 on im2.ModuleID = mod2.ModuleID
    where mod2.DateAndBeginningTime > getdate()

    union all

    select
        t5.TranslatorID,
        t5.FirstName,
        t5.LastName,
        'Translator' as EmployeeType,
        'OnlineSyncModule' as TypeOfActivity,
        om_module.DateAndBeginningTime,
        dateadd(minute, datediff(minute, 0, om_module.Duration), om_module.DateAndBeginningTime) as DateAndEndingTime
    from Translators t5
    join Online_Sync_Modules om_module on t5.TranslatorID = om_module.TranslatorID
    join Modules mod3 on om_module.ModuleID = mod3.ModuleID
    where mod3.DateAndBeginningTime > getdate();
