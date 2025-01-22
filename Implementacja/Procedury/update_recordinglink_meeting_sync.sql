create procedure update_recordinglink_meeting_sync
    @MeetingID int,
    @RecordingLink nvarchar(100)
as begin
    begin try
        -- Sprawdzenie czy dany moduł istnieje
        if not exists(select 1 from Meetings where MeetingID = @MeetingID)
        begin
            throw 50001, 'Podane spotkanie nie istnieje', 1;
        end

        -- Sprawdzenie czy moduł został dodany do tabeli z online-synchronicznie
        if not exists(select 1 from Online_Sync_Meetings where MeetingID = @MeetingID)
        begin
            throw 50002, 'Spotkanie nie jest typu online synchroniczne', 1;
        end

        -- Zaktualizowanie linku do nagrania
        update Online_Sync_Meetings
        set RecordingLink = @RecordingLink
        where MeetingID = @MeetingID
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;