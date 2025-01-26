create procedure set_student_practice_attendance
    @UserID int,
    @StudiesID int,
    @PracticeID int,
    @Present bit
as begin
    begin try
        -- Sprawdzenie poprawności danych
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50001, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        if not exists(select 1 from Studies where StudiesID = @StudiesID)
        begin
            throw 50002, 'Studia o podanym ID nie istnieją', 1;
        end

        if not exists(select 1 from Practices where PracticeID = @PracticeID)
        begin
            throw 50003, 'Praktyki o podanym ID nie istnieją', 1;
        end

        if not exists(select 1 from Users_Practices_Attendance where StudiesID = @StudiesID and PracticeID = @PracticeID
                                                               and UserID = @UserID)
        begin
            throw 50004, 'Użytkownik o podanych studiach i praktykach nie ma wpisu w tabeli', 1;
        end

        -- Ustawienie obecności
        update Users_Practices_Attendance
        set Present = @Present
        where UserID = @UserID and PracticeID = @PracticeID and @StudiesID = StudiesID
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end