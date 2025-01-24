create view financial_report as
    with count_products_sales as (
        select Orders_Details.ProductID, sum(Payment) as total_payment
        from Orders_Details inner join Products on Orders_Details.ProductID = Products.ProductID
        inner join Categories on Products.CategoryID = Categories.CategoryID
        group by Orders_Details.ProductID
    )

    select Products.ProductID, Name, total_payment, total_product_orders
    from Products left join Categories on Products.CategoryID = Categories.CategoryID
    left join count_products_sales on Products.ProductID = count_products_sales.ProductID
    left join products_orders on Products.ProductID = products_orders.ProductID