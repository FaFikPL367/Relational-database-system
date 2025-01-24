create view studie_sign_limit as
    with studie_limits as (
        select Studies.StudiesID, min(Limit) as total_limit
        from Studies inner join Subjects on Studies.StudiesID = Subjects.StudiesID
        inner join Meetings on Subjects.SubjectID = Meetings.SubjectID
        inner join In_person_Meetings on Meetings.MeetingID = In_person_Meetings.MeetingID
        group by Studies.StudiesID
    )

    select Studies.StudiesID, isnull(total_product_orders, 0) as Total_product_orders, isnull(total_limit, 0) as Total_limit
    from Studies left join products_orders on products_orders.ProductID = Studies.StudiesID
    left join studie_limits on studie_limits.StudiesID = Studies.StudiesID
