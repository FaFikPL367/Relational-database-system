create procedure add_meeting(
    @TeacherID int,
    @SubjectID int,
    @ReunionID int,
    @DateAndBeginningTime datetime,
    @Duration time(0),
    @Price money,
    @TypeID int,
    @Status bit,
    @NewMeetingID int OUTPUT
)
as begin
    begin try
        -- Sprawdzenie poprawności wpisanych danych
        if not exists(select 1 from Employees where EmployeeID = @TeacherID)
        begin
            throw 50001, 'Nauczyciel o danym ID nie istnieje', 1;
        end

        if not exists(select 1 from Subjects where SubjectID = @SubjectID)
        begin
            throw 50002, 'Przedmiot o danym ID nie istnieje', 1;
        end

        if not exists(select 1 from Studies_Reunion where ReunionID = @ReunionID)
        begin
            throw 50003, 'Zjazd o danym ID nie istnieje', 1;
        end

        if @Price < 0
        begin
            throw 50004, 'Cena nie może być mniejsza od 0', 1;
        end

        -- Rezerwacja ID w produktach
        declare @NewProductID int;

        insert Products (CategoryID, Status)
        values (3, @Status)

        -- Pobranie ID po dodaniu do produktów
        set @NewMeetingID = SCOPE_IDENTITY();

        -- Wstawienie danych to tabeli
        insert Meetings (TeacherID, SubjectID, ReunionID, DateAndBeginningTime, Duration, Price, TypeID)
        values ( @TeacherID, @SubjectID, @ReunionID, @DateAndBeginningTime, @Duration, @Price, @TypeID);

    end try
    begin catch
        -- Przerzucenie ERRORa dalej
        throw;
    end catch
end;