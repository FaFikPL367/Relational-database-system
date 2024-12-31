create view module_information as
    select ModuleID,
           concat(FirstName, ' ', LastName) as Teacher_full_name,
           CourseID,
           Name,
           Description,
           DateAndBeginningTime,
           Duration,
           TypeName
    from Modules inner join Employees on Modules.TeacherID = Employees.EmployeeID
    inner join Modules_Types on Modules.TypeID = Modules_Types.TypeID;