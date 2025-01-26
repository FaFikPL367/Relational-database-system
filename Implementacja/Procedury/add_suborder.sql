CREATE procedure add_suborder
    @OrderID int,
    @PaymentDeadline date,
    @ExtendedPaymentDeadline date,
    @PaymentDate date,
    @FullPrice money,
    @ProductID int,
    @Payment money
as begin
    begin try
        -- Sprawdzenie, czy dane zamówienie istnieje
        if not exists(select 1 from Orders where OrderID = @OrderID)
        begin
            throw 50000, 'Zamówienie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie, czy dany produkt istnieje
        if not exists(select 1 from Products where ProductID = @ProductID)
        begin
            throw 50000, 'Produkt o podanym ID nie istnieje', 1;
        end

        -- Dodanie danych do tabeli
        insert Orders_Details(OrderID, PaymentDeadline, ExtendedPaymentDeadline, PaymentDate, FullPrice, ProductID, Payment)
        values (@OrderID, @PaymentDeadline, @ExtendedPaymentDeadline,
                @PaymentDate, @FullPrice, @ProductID, @Payment)
    end try
    begin catch
        -- Przerzucenie ERROR-a dalej
        throw;
    end catch
end;