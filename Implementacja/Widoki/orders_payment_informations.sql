create view orders_payment_informations as
    select Orders.OrderID,
           SubOrderID,
           FirstName,
           LastName,
           Orders_Details.ProductID,
           Name,
           case
               when ExtendedPaymentDeadline is null then PaymentDeadline
               else ExtendedPaymentDeadline
           end as offical_payment_deadline,
           FullPrice,
           PaymentDate
    from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
    inner join Users on Orders.UserID = Users.UserID
    inner join Products on Orders_Details.ProductID = Products.ProductID
    inner join Categories on Products.CategoryID = Categories.CategoryID