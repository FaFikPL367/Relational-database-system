create view course_sign_limit as
    with course_limits as (
        select CourseID, min(Limit) as total_limit
        from Modules inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID
        group by CourseID
    )

    select Courses.CourseID, total_product_orders, total_limit
    from Courses left join products_orders on products_orders.ProductID = Courses.CourseID
    left join course_limits on course_limits.CourseID = Courses.CourseID
