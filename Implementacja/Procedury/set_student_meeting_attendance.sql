create procedure set_student_meeting_attendance
    @UserID int,
    @MeetingID int,
    @Present bit
as begin
    begin try
        -- Sprawdzenie poprawności danych
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50001, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        if not exists(select 1 from Meetings where MeetingID = @MeetingID)
        begin
            throw 50002, 'Spotkanie o podanym ID nie istnieje', 1;
        end

        if not exists(select 1 from Users_Meetings_Attendance where MeetingID = @MeetingID and @UserID = UserID)
        begin
            throw 50003, 'Para student-spotkanie nie istnieje', 1;
        end

        -- Ustawienie obecności
        update Users_Meetings_Attendance
        set Present = @Present
        where UserID = @UserID and MeetingID = @MeetingID
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end