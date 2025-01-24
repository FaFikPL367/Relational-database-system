create view meeting_sign_limit as
    with meeting_limits as (
        select Meetings.MeetingID, min(Limit) as total_limit
        from Meetings inner join In_person_Meetings on Meetings.MeetingID = In_person_Meetings.MeetingID
        group by Meetings.MeetingID
    )

    select Meetings.MeetingID, isnull(total_product_orders, 0) as Total_product_orders, isnull(total_limit, 0) as Total_limit
    from Meetings left join products_orders on Meetings.MeetingID = products_orders.ProductID
    left join meeting_limits on meeting_limits.MeetingID = Meetings.MeetingID