create procedure add_user
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Phone varchar(15),
    @Email nvarchar(50),
    @Address nvarchar(50),
    @City nvarchar(30),
    @PostalCode varchar(10),
    @NewUserID int OUTPUT
as
begin
    begin try
        -- Wstawienie danych to tabeli
        insert Users (FirstName, LastName, Phone, Email, Address, City, PostalCode)
        values (@FirstName, @LastName, @Phone, @Email, @Address,
                @City, @PostalCode);

        -- Pobranie ID nowo utworzonego uzytkownika
        set @NewUserID = scope_identity();

    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;