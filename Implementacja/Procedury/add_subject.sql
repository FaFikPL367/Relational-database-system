create procedure add_subject
    @StudiesID int,
    @Name nvarchar(50),
    @Description nvarchar(max)
as begin
    begin try
        -- Sprawdzenie poprawności wpisanych danych
        if not exists(select 1 from Studies where StudiesID = @StudiesID)
        begin
            throw 50001, 'Studia o podanym ID nie istnieją', 1;
        end

        -- Dodanie danych
        insert Subjects (StudiesID, Name, Description)
        values (@StudiesID, @Name, @Description)
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end