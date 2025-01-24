create view financial_report_courses as
    select CourseID, isnull(products_orders.total_product_orders, 0) as Total_product_orders,
           isnull(total_payment, 0) as Total_payment
    from Courses left join products_orders on products_orders.ProductID = CourseID
    left join financial_report on financial_report.ProductID = CourseID