CREATE procedure add_suborder
    @SubOrderID int,
    @OrderID int,
    @PaymentDeadline date,
    @FullPrice money,
    @ProductID int
as begin
    begin try
        -- Sprawdzenie czy dane zamówienie istnieje
        if not exists(select 1 from Orders where OrderID = @OrderID)
        begin
            throw 50000, 'Zamówienie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dany produkt istnieje
        if not exists(select 1 from Products where ProductID = @ProductID)
        begin
            throw 50000, 'Produkt o podanym ID nie istnieje', 1;
        end

        -- Dodanie danych do tabeli
        insert Orders_Details(SubOrderID, OrderID, PaymentDeadline, ExtendedPaymentDeadline, PaymentDate, FullPrice, ProductID, Payment)
        values (@SubOrderID, @OrderID, @PaymentDeadline, null, null, @FullPrice, @ProductID, null)
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;