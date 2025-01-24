create view course_module_types as
    with in_person_count as (
        select CourseID, count(Modules.ModuleID) as in_person
        from Modules inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID
        group by CourseID
    ), online_sync_count as (
        select CourseID, count(Modules.ModuleID) as online_sync
        from Modules inner join Online_Sync_Modules on Modules.ModuleID = Online_Sync_Modules.ModuleID
        group by CourseID
    ), online_async_count as (
        select CourseID, count(Modules.ModuleID) as online_async
        from Modules inner join Online_Async_Modules on Modules.ModuleID = Online_Async_Modules.ModuleID
        group by CourseID
    )

    select Courses.CourseID, ISNULL(in_person, 0) as Total_in_person, isnull(online_sync, 0) as Total_online_sync,
           isnull(online_async, 0) as Total_online_async
    from Courses left join in_person_count on Courses.CourseID = in_person_count.CourseID
    left join online_async_count on Courses.CourseID = online_async_count.CourseID
    left join online_sync_count on Courses.CourseID = online_sync_count.CourseID