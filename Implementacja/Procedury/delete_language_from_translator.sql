create procedure delete_language_from_translator
    @TranslatorID int,
    @LanguageID int
as begin
    begin try
        -- Sprawdzenie czy dana para istnieje
        if not exists(select 1 from Translators_Languages where LanguageID = @languageID and
                                                                TranslatorID = @TranslatorID)
        begin
            throw 50003, 'Taka para już istnieje', 2;
        end
        
        -- W innym przypadku ją usuwamy
        delete from Translators_Languages
               where TranslatorID = @TranslatorID and LanguageID = @languageID;
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end
