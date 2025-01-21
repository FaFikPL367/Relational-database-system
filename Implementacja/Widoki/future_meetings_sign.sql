create view future_meetings_sign as
    with meetings_sign_count as (
        select MeetingID, count(UserID) as sign_count
        from Users_Meetings_Attendance
        group by MeetingID
    )

    select future_meetings.MeetingID, sign_count
    from future_meetings inner join meetings_sign_count on future_meetings.MeetingID = meetings_sign_count.MeetingID;