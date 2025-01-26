create procedure set_student_grade
    @StudiesID int,
    @UserID int,
    @Grade int
as begin
    begin try
        -- Sprawdzenie poprawności danych
        if not exists(select 1 from Studies where StudiesID = @StudiesID)
        begin
            throw 50001, 'Studia o podanym ID nie istnieją', 1;
        end

        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50002, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        if dbo.check_user_enrollment_for_product(@UserID, @StudiesID) = cast(0 as bit)
        begin
            throw 50003, 'Użytkownik nie jest zapisany na podane studia', 1;
        end

        if @Grade < 2 or @Grade > 5
        begin
            throw 50004, 'Podana ocena jest z nie dopuszczalnego przedziału [2,5]', 1;
        end

        -- Ustawienie oceny
        update Users_Studies
        set Grade = @Grade
        where StudiesID = @StudiesID and UserID = @UserID
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end