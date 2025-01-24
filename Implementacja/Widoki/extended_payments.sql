create view extended_payments as
    select SubOrderID, UserID, PaymentDeadline, ExtendedPaymentDeadline,PaymentDate, ProductID
    from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
    where ExtendedPaymentDeadline is not null