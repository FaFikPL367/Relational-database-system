create procedure delete_user_from_product
    @UserID int,
    @ProductID int
as begin
    begin try
        -- Sprawdzenie czy użytkownik istnieje
        if not exists(select 1 from Users where UserID = @UserID)
        begin
            throw 50001, 'Użytkownik o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dana para istnieje
        if dbo.check_user_enrollment_for_product (@UserID, @ProductID) = cast(0 as bit)
        begin
            throw 50002, 'Taka para nie istnieje', 2;
        end

        -- W innym przypadku ją usuwamy

        -- Produkt to STUDIA
        if exists(select 1 from Studies where StudiesID = @ProductID)
        begin
            delete from Users_Studies
            where UserID = @UserID and StudiesID = @ProductID

            -- Stworzenie tabeli ze wszystkimi spotkaniami ze wszystkich zjazdów z danych studiów
            declare @StudiesReunionsMeetingsIDs table (
                MeetingID int
            )

            insert @StudiesReunionsMeetingsIDs
            select m.MeetingID from Studies s
                join Studies_Reunion r on s.StudiesID = r.StudiesID
                join Meetings m on r.ReunionID = m.ReunionID
                where s.StudiesID = @ProductID

            delete uma
            from Users_Meetings_Attendance uma
            join @StudiesReunionsMeetingsIDs srm on uma.MeetingID = srm.MeetingID
            where uma.UserID = @UserID;
        end
        -- Produkt to KURS
        else if exists(select 1 from Courses where CourseID = @ProductID)
        begin
            delete from Users_Courses
            where UserID = @UserID and CourseID = @ProductID

            -- Pobrać tabele z modułami danego kursu
            declare @CourseModuleID table (
                ModuleID int
            )

            -- Zebranie ID modułów danego kursu
            insert @CourseModuleID (ModuleID)
            select ModuleID from Modules where Modules.CourseID = @ProductID

            delete ump
            from Users_Modules_Passes ump
            join @CourseModuleID cm on ump.ModuleID = cm.ModuleID
            where ump.UserID = @UserID;
        end
        -- Produkt to WEBINAR
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