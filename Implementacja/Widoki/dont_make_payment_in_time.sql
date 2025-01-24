create view dont_make_payment_in_time as
    select UserID,
           case
            when ExtendedPaymentDeadline is not null then ExtendedPaymentDeadline
            else PaymentDeadline
        end offical_payment_date,
        PaymentDate,
        ProductID
    from Orders_Details inner join Orders on Orders_Details.OrderID = Orders.OrderID
    where
        case
            when ExtendedPaymentDeadline is not null then ExtendedPaymentDeadline
            else PaymentDeadline
        end < Orders_Details.PaymentDate

