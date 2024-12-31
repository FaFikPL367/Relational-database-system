create view course_information as
    with count_modules as (select CourseID, count(ModuleID) as count_module
                           from Modules
                           group by CourseID
    ), limit_for_course as (select Courses.CourseID, min(Limit) as min_limit
                            from Courses inner join Modules on Courses.CourseID = Modules.CourseID
                            inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID
                            group by Courses.CourseID)

    select Courses.CourseID,
           Name,
           Description,
           concat(FirstName, ' ', LastName) as Coordinator_full_name,
           StartDate,
           EndDate,
           isnull(count_module, 0) as Total_modules,
           min_limit as Total_places
    from Courses left join Employees on Courses.CoordinatorID = Employees.EmployeeID
    left join count_modules on Courses.CourseID = count_modules.CourseID
    left join limit_for_course on Courses.CourseID = limit_for_course.CourseID;