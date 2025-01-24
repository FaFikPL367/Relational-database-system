create view financial_report_studies as
    with payment_for_all_reunions as (
        select Studies_Reunion.StudiesID, count(Payment_for_reunions.ReunionID) * Price as Total_reunions_payment
        from Studies_Reunion inner join Payment_for_reunions on Studies_Reunion.ReunionID = Payment_for_reunions.ReunionID
        where IsPaid = 1
        group by Studies_Reunion.StudiesID, Price
    )

    select Studies.StudiesID, isnull(products_orders.total_product_orders, 0) as Total_product_orders,
           isnull(total_payment, 0) as Total_payment, Total_reunions_payment
    from Studies left join products_orders on products_orders.ProductID = StudiesID
    left join financial_report on financial_report.ProductID = StudiesID
    left join payment_for_all_reunions on Studies.StudiesID = payment_for_all_reunions.StudiesID