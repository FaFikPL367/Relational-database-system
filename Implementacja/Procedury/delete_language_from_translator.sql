CREATE procedure delete_language_from_translator
    @TranslatorID int,
    @LanguageID int
as begin
    begin try
        -- Sprawdzenie czy tłumacz istnieje
        if not exists(select 1 from Translators where TranslatorID = @TranslatorID)
        begin
            throw 50001, 'Tłumacz o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy język istnieje
        if not exists(select 1 from Languages where LanguageID = @LanguageID)
        begin
            throw 50002, 'Język o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie czy dana para istnieje
        if dbo.check_translator_language(@TranslatorID, @LanguageID) = cast(0 as bit)
        begin
            throw 50003, 'Taka para już istnieje', 2;
        end

        -- W innym przypadku ją usuwamy
        delete from Translators_Languages
        where TranslatorID = @TranslatorID and LanguageID = @languageID;
    end try
    begin catch
        -- Przerzucenie błędu dalej
        throw;
    end catch
end;