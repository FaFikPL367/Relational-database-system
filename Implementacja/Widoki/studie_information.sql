create view studie_information as
    with count_subjects as (select StudiesID, count(SubjectID) as total_subjects
                            from Subjects
                            group by StudiesID
    ), count_meetings as (select StudiesID, count(MeetingID) as total_meetings
                          from Meetings
                                   inner join Subjects on Meetings.SubjectID = Subjects.SubjectID
                          group by StudiesID
    ), limit_for_studie as (select StudiesID, min(Limit) as min_limit
                            from In_person_Meetings inner join Meetings on In_person_Meetings.MeetingID = Meetings.MeetingID
                            inner join Subjects on Meetings.SubjectID = Subjects.SubjectID
                            group by StudiesID
    )

    select Studies.StudiesID,
           concat(FirstName, ' ', LastName) as Coordinator_full_name,
           Name,
           Description,
           StartDate,
           EndDate,
           Price,
           isnull(total_subjects, 0) as Total_subjects,
           isnull(total_meetings, 0) as Total_meetings,
           min_limit as Total_places
    from Studies left join Employees on Studies.CoordinatorID = Employees.EmployeeID
    left join count_subjects on Studies.StudiesID = count_subjects.StudiesID
    left join count_meetings on Studies.StudiesID = count_meetings.StudiesID
    left join limit_for_studie on Studies.StudiesID = limit_for_studie.StudiesID;