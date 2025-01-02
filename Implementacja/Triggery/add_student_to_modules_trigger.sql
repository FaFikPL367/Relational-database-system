create trigger add_student_to_modules_trigger
    on Users_Courses
    after insert
as begin
    begin try
        declare @UserID int, @CourseID int;

        select @UserID = UserID, @CourseID = CourseID
        from inserted;

        -- Pobrać tabele z modułami danego kursu
        declare @CourseModuleID table (
            ModuleID int
        );

        insert @CourseModuleID (ModuleID)
        select ModuleID from Modules where Modules.CourseID = @CourseID;

        -- Dodanie wartości użytkownika do danego modułu
        insert Users_Modules_Passes (UserID, ModuleID, Passed)
        select @UserID, ModuleID, null
        from @CourseModuleID;

        print 'Pomyślnie dodano użytkownika do modułów';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end