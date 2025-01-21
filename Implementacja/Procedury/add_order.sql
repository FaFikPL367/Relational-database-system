CREATE procedure add_order
    @OrderID int,
    @UserID int,
    @OrderDate date,
    @PaymentLink nvarchar(100)
as begin
    begin try
        -- Sprawdzenie czy dany użytkownik istnieje
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50000, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        -- Dodanie danych do tabeli
        insert Orders(OrderID, UserID, OrderDate, PaymentLink)
        values (@OrderID, @UserID, @OrderDate, @PaymentLink)
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;