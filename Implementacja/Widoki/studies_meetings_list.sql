create view studies_meetings_list as
    select
        Users_Meetings_Attendance.MeetingID,
        format(DateAndBeginningTime, 'yyyy-mm-dd') as date,
        FirstName,
        LastName,
        Present
    from Users_Meetings_Attendance inner join Users on Users_Meetings_Attendance.UserID = Users.UserID
    inner join Meetings on Users_Meetings_Attendance.MeetingID = Meetings.MeetingID