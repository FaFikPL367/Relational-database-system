create view financial_report_webinar as
    select WebinarID, isnull(products_orders.total_product_orders, 0) as Total_product_orders,
           isnull(total_payment, 0) as Total_payment
    from Webinars left join products_orders on products_orders.ProductID = WebinarID
    left join financial_report on financial_report.ProductID = WebinarID
