create view studies_practice_attendances as
    select FirstName,
           LastName,
           StudiesID,
           PracticeID,
           Present
    from Users_Practices_Attendance inner join Users on Users.UserID = Users_Practices_Attendance.UserID