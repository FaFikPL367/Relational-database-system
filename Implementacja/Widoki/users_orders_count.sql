create view users_orders_count as
    with webinars_count as (
        select UserID, count(Products.ProductID) as Total_webinars
        from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
        inner join Products on Orders_Details.ProductID = Products.ProductID
        inner join Categories on Products.CategoryID = Categories.CategoryID
        where Name = 'Webinar'
        group by UserID
    ), courses_count as (
        select UserID, count(Products.ProductID) as Total_courses
        from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
        inner join Products on Orders_Details.ProductID = Products.ProductID
        inner join Categories on Products.CategoryID = Categories.CategoryID
        where Name = 'Course'
        group by UserID
    ), studies_count as (
        select UserID, count(Products.ProductID) as Total_studies
        from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
        inner join Products on Orders_Details.ProductID = Products.ProductID
        inner join Categories on Products.CategoryID = Categories.CategoryID
        where Name = 'Studies'
        group by UserID
    ), meetings_count as (
        select UserID, count(Products.ProductID) as Total_meetings
        from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
        inner join Products on Orders_Details.ProductID = Products.ProductID
        inner join Categories on Products.CategoryID = Categories.CategoryID
        where Name = 'Meeting'
        group by UserID
    )

    select FirstName, LastName, isnull(Total_webinars, 0) as Total_webinars,
           isnull(Total_courses, 0) as Total_courses,
           isnull(Total_studies, 0) as Total_studies,
           isnull(Total_meetings, 0) as Total_meetings
    from Users left join courses_count on Users.UserID = courses_count.UserID
    left join webinars_count on Users.UserID = webinars_count.UserID
    left join studies_count on Users.UserID = studies_count.UserID
    left join meetings_count on Users.UserID = meetings_count.UserID