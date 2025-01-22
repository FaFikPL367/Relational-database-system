create trigger add_reunions_to_suborders_trigger
    on Orders_Details
    after insert
as begin
    begin try
        set nocount on; -- dla poprawy wydajności

        declare @CategoryName nvarchar(15);
        declare @ProductID int;
        declare @OrderID int;

        -- Wyciągniecie ID produktu
        select @ProductID = ProductID, @OrderID = OrderID from inserted;

        -- Znalezienie nazwy kategorii kupionego produktu
        select @CategoryName = Name from Products inner join Categories on Products.CategoryID = Categories.CategoryID
                                                          where Products.ProductID = @ProductID;

        if @CategoryName = 'Studies'
        begin
            -- Sprawdzenie, czy użytkownik już jest zapisany na dane studia
            if exists(select UserID from inserted inner join Orders_Details on inserted.SubOrderID = Orders_Details.SubOrderID
                                    inner join Orders on Orders_Details.OrderID = Orders.OrderID
                                    where UserID in (select distinct UserID from Users_Studies inner join inserted on inserted.ProductID = Users_Studies.StudiesID))
            begin
                throw 50001, 'Użytkownik o podanym ID jest już zapisany na te studia', 1;
            end

            -- W przeciwnym wypadku dodajemy do Orders_Details podzamówienia ze wszystkimi zjazdami z danych studiów

            declare @allReunionsForStudies table (
                    PaymentDeadline date,
                    FullPrice money,
                    ReunionID int,
            )

            insert @allReunionsForStudies (PaymentDeadline, FullPrice, ReunionID)
            select datediff(day, 3, r.StartDate), s.Price / 7, r.ReunionID from Studies_Reunion r
                join Studies s on r.StudiesID = s.StudiesID

            insert Orders_Details (OrderID, PaymentDeadline, FullPrice, ProductID)
            select @OrderID, PaymentDeadline, FullPrice, ReunionID
            from @allReunionsForStudies;
        end
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;

