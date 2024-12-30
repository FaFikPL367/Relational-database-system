CREATE procedure add_course_module_sync
    @ModuleID int,
    @MeetingLink nvarchar(100),
    @RecordingLink nvarchar(100),
    @TranslatorID int,
    @LanguageID int
as begin
    begin try
        -- Sprawdzenie czy dany moduł istnieje
        if not exists(select 1 from Modules where ModuleID = @ModuleID)
        begin
            throw 50000, 'Moduł o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie poprawności podanego typu
        if not exists(select 1 from Modules inner join Modules_Types on Modules.TypeID = Modules_Types.TypeID
                               where TypeName = 'Online Sync' and ModuleID = @ModuleID)
        begin
            throw 50001, 'Podany moduł nie jest typu online-synchronicznie', 1;
        end

        -- Sprawdzenie czy dany tłumacz istnieje
        if not exists(select 1 from Translators where TranslatorID = @TranslatorID) and @TranslatorID is not null
        begin
            throw 50002, 'Tłumacz o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dany język istnieje
        if not exists(select 1 from Languages where LanguageID = @LanguageID)
        begin
            throw 50003, 'Język o podanym ID nie istnieje', 1;
        end

        -- Sprawdzzenie dostępności tłumacza
        if dbo.check_translator_availability(@TranslatorID, (select DateAndBeginningTime from Modules where ModuleID = @ModuleID),
           (select Duration from Modules where ModuleID = @ModuleID)) = cast(1 as bit)
        begin
            throw 50004, 'Tłumacz w okresie danego modułu jest nie dostępny', 1;
        end

        insert Online_Sync_Modules(ModuleID, MeetingLink, RecordingLink, TranslatorID, LanguageID)
        values (@ModuleID, @MeetingLink, @RecordingLink, @TranslatorID, @LanguageID)

        print 'Pomyślnie dodany moduł synchroniczny';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end
go

