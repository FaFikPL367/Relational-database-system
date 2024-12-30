create procedure assign_translator_to_languages
    @TranslatorID int,
    @LanguageID int
as begin
    begin try
        -- Sprawdzenie czy jezyk o danym ID istnieje
        if not exists(select 1 from Languages where LanguageID = @LanguageID)
        begin
            throw 50001, 'Jezyk nie istnieje', 1;
        end

        -- Sprawdzenie czy tlumacz o danym ID istnieje
        if not exists(select 1 from Translators where TranslatorID = @TranslatorID)
        begin
            throw 50002, 'Tłumacz nie istnieje', 1;
        end

        -- Sprawdzenie czy taki wpis już istnieje
        if dbo.check_translator_language(@TranslatorID, @LanguageID) = cast(1 as bit)
        begin
            throw 50003, 'Taka para już istnieje', 1;
        end

        -- W innych przypadkach dodajemy pare
        insert Translators_Languages (TranslatorID, LanguageID)
        values (@TranslatorID, @LanguageID)

        print 'Pomyślne dodanie jezyka do tlumacza';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end
go

