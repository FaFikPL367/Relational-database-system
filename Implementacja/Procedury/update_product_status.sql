create procedure update_product_status
    @ProductID int,
    @Status bit
as begin
    begin try
        -- Sprawdzenie poprawności danych
        if not exists(select 1 from Products where ProductID = @ProductID)
        begin
            throw 50001, 'Produkt o danym ID nie istnieje', 1;
        end

        -- Aktualizacja danych
        update Products
        set Status = @Status
        where ProductID = @ProductID
    end try
    begin catch
        -- Przerzucenie błędy dalej
        throw;
    end catch
end