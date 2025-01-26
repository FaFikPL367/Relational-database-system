CREATE procedure add_order
    @UserID int,
    @OrderDate date,
    @PaymentLink nvarchar(100),
    @LastID int output
as begin
    begin try
        -- Sprawdzenie, czy dany użytkownik istnieje
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50000, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        -- Dodanie danych do tabeli
        insert Orders(UserID, OrderDate, PaymentLink)
        values (@UserID, @OrderDate, @PaymentLink)

        SET @LastID = SCOPE_IDENTITY();
    end try
    begin catch
        -- Przerzucenie ERROR-a dalej
        throw;
    end catch
end;