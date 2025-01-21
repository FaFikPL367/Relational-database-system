create procedure set_extended_payment_deadline (
    @SubOrderID int,
    @ExtendedPaymentDeadline date
)
as begin
    begin try
        -- Sprawdzenie czy podzamówienie istnieje
        if not exists(select 1 from Orders_Details where SubOrderID = @SubOrderID)
        begin
            throw 50000, 'Podzamówienie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy data przedłużonego terminu jest późniejsza od początkowej daty
        if ((select PaymentDeadline from Orders_Details where SubOrderID = @SubOrderID) > @ExtendedPaymentDeadline)
        begin
            throw 50001, 'Podana data jest nieprawidłowa', 1;
        end

        -- Aktualizacja daty przedłużonego terminu
        update Orders_Details
        set ExtendedPaymentDeadline = @ExtendedPaymentDeadline
        where SubOrderID = @SubOrderID
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;