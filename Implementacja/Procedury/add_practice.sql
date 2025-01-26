create procedure add_practice
    @Description nvarchar(max),
    @CompanyName nvarchar(30),
    @Country nvarchar(30),
    @City nvarchar(30),
    @Address nvarchar(50),
    @Phone nvarchar(20),
    @Email nvarchar(50)
as begin
    begin try
        -- Dodaawanie danych
        insert Practices (Description, CompanyName, Country, City, Address, Phone, Email)
        values (@Description, @CompanyName, @Country, @City, @Address, @Phone, @Email)
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end