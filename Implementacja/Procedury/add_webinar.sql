CREATE procedure add_webinar
    @Name nvarchar(30),
    @Description nvarchar(max),
    @DateAndBeginningTIme datetime,
    @Duration time(0),
    @CoordinatorID int,
    @TeacherID int,
    @TranslatorID int,
    @Price int,
    @LanguageID int,
    @RecordingLink nvarchar(100),
    @MeetingLink nvarchar(100),
    @Status bit
as begin
    begin try
        begin transaction;

        -- Sprawdzenie poprawności wpisywanych danych
        if not exists(select 1 from Employees where EmployeeID = @CoordinatorID and
                                                    PositionID = 2)
        begin
            throw 50001, 'Koordynator o danym ID nie istnieje lub nie jest koordynatorem webinarów', 1;
        end

        if not exists(select 1 from Employees where EmployeeID = @TeacherID)
        begin
            throw 50002, 'Nauczyciel o danym ID nie istnieje', 1;
        end

        if @Price < 0
        begin
            throw 50003, 'Cena nie może być mniejsza od 0', 1;
        end

        if not exists(select 1 from Languages where LanguageID = @LanguageID)
        begin
            throw 50004, 'Język o danym ID nie istnieje', 1;
        end

        if not exists(select 1 from Translators where @TranslatorID = TranslatorID) and @TranslatorID IS NOT NULL
        begin
            throw 50005, 'Tłumacz o danym ID nie istnieje', 1;
        end

        if dbo.check_translator_language(@TranslatorID, @LanguageID) = cast(0 as bit)
        begin
            throw 50006, 'Para tłumacz-język nie istnieje', 1;
        end

        -- W innym przypadku możemy dodać
        -- Rezerwacja ID w produktach
        declare @NewProductID int;
        declare @CategoryID int = (select CategoryID from Categories where Name = 'Webinar')

        insert Products (CategoryID, Status)
        values (@CategoryID, @Status)

        -- Pobranie ID po dodaniu do produktów
        set @NewProductID = SCOPE_IDENTITY();

        -- Dodanie do tabeli ze Webinarami
        insert Webinars (WebinarID, Name, Description, DateAndBeginningTime, Duration, TeacherID, TranslatorID, Price, LanguageID, RecordingLink, MeetingLink, CoordinatorID)
        values (@NewProductID, @Name, @Description, @DateAndBeginningTIme, @Duration, @TeacherID, @TranslatorID, @Price, @LanguageID, @RecordingLink, @MeetingLink, @CoordinatorID)

        commit transaction;
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction;
        end;

        -- Przerzucenie ERROR-a dalej
        throw;
    end catch
end;

