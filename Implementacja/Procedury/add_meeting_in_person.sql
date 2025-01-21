CREATE procedure add_meeting_in_person
    @MeetingID int,
    @Classroom int,
    @TranslatorID int,
    @LanguageID int,
    @Limit int
as begin
    begin try
        -- Sprawdzenie czy dany moduł istnieje
        if not exists(select 1 from Meetings where MeetingID = @MeetingID)
        begin
            throw 50000, 'Spotkanie o podanym ID nie istnieje', 1;
        end

        -- Sprawdzenie poprawności podanego typu
        if not exists(select 1 from Meetings inner join Types on Meetings.TypeID = Types.TypeID
                               where TypeName = 'In-person' and MeetingID = @MeetingID)
        begin
            throw 50001, 'Podane spotkanie nie jest typu stacjonarnego', 1;
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

        -- Sprawdzenie czy limit jest poprawnie wpisany
        if @Limit <= 0
        begin
            throw 50004, 'Limit nie może być wartością mniejszą bądź równą 0', 1;
        end

        -- Sprawdzenie czy podana sala jest wolna w tym okresie
        if dbo.check_classroom_availability(@Classroom, @MeetingID) = cast(1 as bit)
        begin
            throw 50005, 'Sala w okresie trwania spotkania nie dostępna', 1;
        end

        -- Sprawdzenie dostępności tłumacza
        if dbo.check_translator_availability(@TranslatorID, (select DateAndBeginningTime from Meetings where MeetingID = @MeetingID),
           (select Duration from Meetings where MeetingID = @MeetingID)) = cast(1 as bit)
        begin
            throw 50006, 'Tłumacz w okresie trwania danego spotkania jest nie dostępny', 1;
        end

        insert In_person_Meetings(MeetingID, Classroom, TranslatorID, LanguageID, Limit)
        values (@MeetingID, @Classroom, @TranslatorID, @LanguageID, @Limit)
    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;