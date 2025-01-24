create view course_sign_limit as
    with course_limits as (
        select CourseID, min(Limit) as total_limit
        from Modules inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID
        group by CourseID
    )

    select Courses.CourseID, isnull(total_product_orders, 0) as Total_quantity_product_orders, isnull(total_limit, 0) as Total_limit
    from Courses left join products_orders on products_orders.ProductID = Courses.CourseID
    left join course_limits on course_limits.CourseID = Courses.CourseID
