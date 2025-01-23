create trigger add_meetings_to_attendance_trigger
    on Users_Studies
    after insert
as begin
    begin try
        declare @UserID int, @StudiesID int;

        -- Pobranie informacji o studiach i użytkowniku po kupieniu
        select @UserID = UserID, @StudiesID = StudiesID
        from inserted;

        -- Stworzenie tabeli ze wszystkimi spotkaniami ze wszystkich zjazdów z danych studiów
        declare @StudiesReunionsMeetingsIDs table (
            MeetingID int
        );

        -- Zebranie ID spotkań ze wszystkich zjazdów z danych studiów
        insert @StudiesReunionsMeetingsIDs
        select m.MeetingID from Studies s
            join Studies_Reunion r on s.StudiesID = r.StudiesID
            join Meetings m on r.ReunionID = m.ReunionID
            where s.StudiesID = @StudiesID;

        -- Dodanie pola przechowującego informację o obecności użytkownika na danym spotkaniu
        insert Users_Meetings_Attendance (UserID, MeetingID, Present)
        select @UserID, MeetingID, null
        from @StudiesReunionsMeetingsIDs;
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end