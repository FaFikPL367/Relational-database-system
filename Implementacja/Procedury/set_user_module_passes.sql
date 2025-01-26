create procedure set_user_module_passes
    @UserID int,
    @ModuleID int,
    @Passed bit
as begin
    begin try
        -- Sprawdzenie poprawności danych
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50001, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        if not exists(select 1 from Modules where ModuleID = @ModuleID)
        begin
            throw 50002, 'Moduł o podanym ID nie istnieje', 1;
        end

        if not exists(select 1 from Users_Modules_Passes where ModuleID = @ModuleID and @UserID = UserID)
        begin
            throw 50003, 'Para użytkownik-moduł nie istnieje', 1;
        end

        -- Ustawienie obecności
        update Users_Modules_Passes
        set Passed = @Passed
        where UserID = @UserID and ModuleID = @ModuleID
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end