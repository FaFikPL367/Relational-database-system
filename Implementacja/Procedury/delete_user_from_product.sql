create function delete_user_from_product(
    @UserID int,
    @ProductID int
)
as begin
    begin try
        -- Sprawdzenie czy użytkownik istnieje
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50001, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dana para istnieje
        if dbo.check_user_enlistment_for_product(@UserID, @ProductID) = cast(0 as bit)
        begin
            throw 50002, 'Taka para nie istnieje', 2;
        end

        -- W innym przypadku ją usuwamy
        if exists(select 1 from Studies where StudiesID = @ProductID)
        begin
            delete from Users_Studies
            where UserID = @UserID and StudiesID = @ProductID;
        end

        else if exists(select 1 from Courses where CourseID = @ProductID)
        begin
            delete from Users_Courses
            where UserID = @UserID and CourseID = @ProductID;
        end

        else
        begin
            delete from Users_Webinars
            where UserID = @UserID and WebinarID = @ProductID;
        end
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end;