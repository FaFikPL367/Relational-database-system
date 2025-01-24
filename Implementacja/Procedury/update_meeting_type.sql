CREATE procedure update_meeting_type
    @MeetingID int,
    @TypeID int
as begin
    begin try
        -- Sprawdzenie czy moduł istnieje
        if not exists(select 1 from Meetings where @MeetingID = MeetingID)
        begin
            throw 50000, 'Spotkanie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dany typ istnieje
        if not exists(select 1 from Types where TypeID = @TypeID)
        begin
            throw 50001, 'Podany typ nie istnieje', 1;
        end

        -- Sprawdzenie czy nie zmieniasz typu spotkania na tem sam typ
        if exists(select 1 from Meetings where @MeetingID = MeetingID and @TypeID = TypeID)
        begin
            throw 50002, 'Zmieniasz typ spotkania na ten sam typ co był ustawiony', 1;
        end

        declare @OldType int = (select TypeID from Meetings where MeetingID = @MeetingID)
        declare @OldTypeName varchar(20);
        set @OldTypeName = (select TypeName from Types where TypeID = @OldType)

        -- Aktualizacja typu
        update Meetings
        set TypeID = @TypeID
        where MeetingID = @MeetingID

        -- Usuniędzie danych ze starego typu
        if @OldTypeName = 'In-person'
        begin
            if exists(select 1 from In_person_Meetings where MeetingID = @MeetingID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from In_person_Meetings
                where MeetingID = @MeetingID
            end
        end

        if @OldTypeName = 'Online Sync'
        begin
            if exists(select 1 from Online_Sync_Meetings where MeetingID = @MeetingID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from Online_Sync_Meetings
                where MeetingID = @MeetingID
            end
        end

        if @OldTypeName = 'Online Async'
        begin
            if exists(select 1 from Online_Async_Meetings where MeetingID = @MeetingID)
            begin
                -- Informacje zostały dodane i można usunąć informacje
                delete from Online_Async_Meetings
                where MeetingID = @MeetingID
            end
        end
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;

