CREATE procedure add_employee
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Phone varchar(15),
    @Email nvarchar(50),
    @Address nvarchar(50),
    @City nvarchar(30),
    @PostalCode varchar(10),
    @PositionID int,
    @NewEmployeeID int OUTPUT
as
begin

    begin try
        -- Sprawdzenie czy dana pozycja istnieje
        if not exists(select 1 from Employees_Postions where PositionID = @PositionID)
        begin
            throw 51000, 'Pozycja nie istnieje ', 1;
        end

        -- Wstawienie danych to tabeli
        insert Employees (FirstName, LastName, Phone, Email, Address, City, PostalCode, PositionID)
        values (@FirstName, @LastName, @Phone, @Email, @Address,
                @City, @PostalCode, @PositionID);

        -- Pobranie ID nowo utworzonego uzytkownika
        set @NewEmployeeID = scope_identity();
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end;