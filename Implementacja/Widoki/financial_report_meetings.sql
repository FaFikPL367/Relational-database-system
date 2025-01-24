create view financial_report_meetings as
    select MeetingID, isnull(products_orders.total_product_orders, 0) as Total_product_orders,
           isnull(total_payment, 0) as Total_payment
    from Meetings left join products_orders on products_orders.ProductID = MeetingID
    left join financial_report on financial_report.ProductID = MeetingID
