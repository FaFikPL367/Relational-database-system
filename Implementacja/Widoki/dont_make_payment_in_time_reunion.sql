create view dont_make_payment_in_time_reunion as
    select UserID,
           Payment_for_reunions.PaymentDate,
           Payment_for_reunions.PaymentDeadline,
           ReunionID
    from Payment_for_reunions inner join Orders_Details on Payment_for_reunions.SubOrderID = Orders_Details.SubOrderID
    inner join Orders on Orders_Details.OrderID = Orders.OrderID
    where Payment_for_reunions.PaymentDeadline < Payment_for_reunions.PaymentDate