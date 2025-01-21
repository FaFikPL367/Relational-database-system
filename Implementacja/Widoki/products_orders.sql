create view products_orders as
    select ProductID, count(SubOrderID) as total_product_orders
    from Orders_Details
    group by ProductID