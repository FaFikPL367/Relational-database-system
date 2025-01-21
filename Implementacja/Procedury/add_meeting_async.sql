CREATE procedure add_meeting_async
    @MeetingID int,
    @RecordingLink nvarchar(100)
as begin
    begin try
        -- Sprawdzenie czy dane spotkanie istnieje
        if not exists(select 1 from Meetings where MeetingID = @MeetingID)
        begin
            throw 50000, 'Spotkanie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie poprawności podanego typu
        if not exists(select 1 from Meetings inner join Types on Meetings.TypeID = Types.TypeID
                               where TypeName = 'Online Async' and MeetingID = @MeetingID)
        begin
            throw 50001, 'Podane spotkanie nie jest typu online-asynchronicznie', 1;
        end

        insert Online_Async_Meetings(MeetingID, RecordingLink)
        values (@MeetingID, @RecordingLink)
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;
