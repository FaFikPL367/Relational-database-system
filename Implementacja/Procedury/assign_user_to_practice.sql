create procedure assign_user_to_practice
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

        if dbo.check_user_enrollment_for_product(@UserID, @StudiesID) = cast(0 as bit)
        begin
            throw 50004, 'Użytkownik nie jest zapisany na dane studia', 1;
        end

        -- Dodanie danych
        insert Users_Practices_Attendance (UserID, StudiesID, PracticeID, Present)
        values (@UserID, @StudiesID, @PracticeID, @Present)
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end