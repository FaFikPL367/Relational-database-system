create procedure add_reunion
    @StudiesID int,
    @StartDate date,
    @EndDate date,
    @Price money
as begin
    begin try
        -- Sprawdzenie poprawności wpisanych danych
        if not exists(select 1 from Studies where StudiesID = @StudiesID)
        begin
            throw 50001, 'Studia o podanym ID nie istnieją', 1;
        end

        if @StartDate >= @EndDate
        begin
            throw 50002, 'Data startowa nie może być późniejsza niż data końca', 1;
        end

        if @Price <= 0
        begin
            throw 50003, 'Cena za zjazd nie moze być ujeman lub równa 0', 1;
        end

        insert Studies_Reunion(StudiesID, StartDate, EndDate, Price)
        values (@StudiesID, @StartDate, @EndDate, @Price)
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end