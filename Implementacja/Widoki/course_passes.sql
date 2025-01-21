create view course_passes as
    select CourseID,
           Modules.ModuleID,
           FirstName,
           LastName,
           Passed
    from Users_Modules_Passes inner join Modules on Users_Modules_Passes.ModuleID = Modules.ModuleID
    inner join Users on Users_Modules_Passes.UserID = Users.UserID