create trigger add_reunions_to_suborders_trigger
    on Orders_Details
    after insert
as begin
    begin try
        set nocount on; -- dla poprawy wydajności

        declare @CategoryName nvarchar(15);
        declare @ProductID int;
        declare @SubOrderID int;

        -- Wyciągniecie ID produktu
        select @ProductID = ProductID, @SubOrderID = SubOrderID from inserted;

        -- Znalezienie nazwy kategorii kupionego produktu
        select @CategoryName = Name from Products inner join Categories on Products.CategoryID = Categories.CategoryID
                                                          where Products.ProductID = @ProductID;

        if @CategoryName = 'Studies'
        begin
            -- Sprawdzenie, czy użytkownik już jest zapisany na dane studia
            if not exists(select UserID from inserted inner join Orders_Details on inserted.SubOrderID = Orders_Details.SubOrderID
                                    inner join Orders on Orders_Details.OrderID = Orders.OrderID
                                    where UserID in (select distinct UserID from Users_Studies inner join inserted on inserted.ProductID = Users_Studies.StudiesID))
            begin
                throw 50001, 'Użytkownik nie został dodany do studiów', 1;
            end

            -- W przeciwnym wypadku dodajemy do Orders_Details podzamówienia ze wszystkimi zjazdami z danych studiów
            declare @allReunionsForStudies table (
                    PaymentDeadline date,
                    FullPrice money,
                    ReunionID int
            )

            insert @allReunionsForStudies (PaymentDeadline, FullPrice, ReunionID)
            select dateadd(day, -3, r.StartDate), r.Price, r.ReunionID
                from Studies_Reunion r

            insert Payment_for_reunions (SubOrderID, ReunionID, PaymentDeadline, PaymentDate, IsPaid)
            select @SubOrderID, ReunionID, PaymentDeadline, null, null
            from @allReunionsForStudies;
        end
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;

