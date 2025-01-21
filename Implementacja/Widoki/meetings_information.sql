create view meetings_information as
    select MeetingID,
           FirstName,
           LastName,
           Name,
           ReunionID,
           DateAndBeginningTime,
           Duration,
           Price,
           TypeName
    from Meetings inner join Employees on Meetings.TeacherID = Employees.EmployeeID
    inner join Subjects on Meetings.SubjectID = Subjects.SubjectID
    inner join Types on Meetings.TypeID = Types.TypeID