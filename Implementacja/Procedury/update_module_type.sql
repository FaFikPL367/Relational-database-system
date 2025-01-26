CREATE procedure update_module_type
    @ModuleID int,
    @TypeID int
as begin
    begin try
        -- Sprawdzenie, czy moduł istnieje
        if not exists(select 1 from Modules where ModuleID = @ModuleID)
        begin
            throw 50000, 'Moduł o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie, czy dany typ istnieje
        if not exists(select 1 from Types where TypeID = @TypeID)
        begin
            throw 50001, 'Podany typ nie istnieje', 1;
        end

        -- Sprawdzenie, czy nie zmieniasz na ten sam typ
        if exists(select 1 from Modules where ModuleID = @ModuleID and TypeID = @TypeID)
        begin
            throw 50002, 'Zmieniasz typ modułu na ten sam typ', 1;
        end

        declare @OldType int = (select TypeID from Modules where ModuleID = @ModuleID)
        declare @OldTypeName varchar(20);
        set @OldTypeName = (select TypeName from Types where TypeID = @OldType)

        -- Aktualizacja typu
        update Modules
        set TypeID = @TypeID
        where ModuleID = @ModuleID

        -- Usunięcie danych ze starego typu
        if @OldTypeName = 'In-person'
        begin
            if exists(select 1 from In_person_Modules where ModuleID = @ModuleID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from In_person_Modules
                where ModuleID = @ModuleID
            end
        end

        if @OldTypeName = 'Online Sync'
        begin
            if exists(select 1 from Online_Sync_Modules where ModuleID = @ModuleID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from Online_Sync_Modules
                where ModuleID = @ModuleID
            end
        end

        if @OldTypeName = 'Online Async'
        begin
            if exists(select 1 from Online_Async_Modules where ModuleID = @ModuleID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from Online_Async_Modules
                where ModuleID = @ModuleID
            end
        end
    end try
    begin catch
        -- Przerzucenie ERROR-a dalej
        throw;
    end catch
end;