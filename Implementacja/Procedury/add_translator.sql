create procedure add_translator
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Phone varchar(15),
    @Email nvarchar(50),
    @Address nvarchar(50),
    @City nvarchar(30),
    @PostalCode varchar(10),
    @NewTranslatorID int OUTPUT
as
begin
    begin try
        -- Wstawienie danych to tabeli
        insert Translators (FirstName, LastName, Phone, Email, Address, City, PostalCode)
        values (@FirstName, @LastName, @Phone, @Email, @Address,
                @City, @PostalCode);

        -- Pobranie ID nowo utworzonego uzytkownika
        set @NewTranslatorID = scope_identity();

        print 'Pomyślne dodanie uzytkownika';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
        set @NewTranslatorID = null; -- W razie błędu zwróć NULL
    end catch
end;