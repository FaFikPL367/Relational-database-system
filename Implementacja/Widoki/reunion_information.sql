create view reunion_information as
    with count_meetings_in_reunion as (
        select ReunionID, count(MeetingID) as Total_meetings
        from Meetings
        group by ReunionID
    )

    select Studies_Reunion.ReunionID, StudiesID, Price, StartDate, EndDate, Total_meetings
    from Studies_Reunion inner join count_meetings_in_reunion
        on Studies_Reunion.ReunionID = count_meetings_in_reunion.ReunionID
