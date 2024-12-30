CREATE procedure update_module_type
    @ModuleID int,
    @TypeID int
as begin
    begin try
        -- Sprawdzenie czy moduł istnieje
        if not exists(select 1 from Modules where ModuleID = @ModuleID)
        begin
            throw 50000, 'Moduł o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dany typ istnieje
        if not exists(select 1 from Modules_Types where TypeID = @TypeID)
        begin
            throw 50001, 'Podany typ nie istnieje', 1;
        end

        update Modules
        set TypeID = @TypeID
        where ModuleID = @ModuleID

        -- Usunięcie modułu z tabeli ze starego typu

        print 'Pomyślne zmienie typu modułu';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end
go

