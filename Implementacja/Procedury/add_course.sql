CREATE procedure add_course
    @CoordinatorID int,
    @Name nvarchar(30),
    @Description nvarchar(max),
    @StartDate date,
    @EndDate date,
    @Price money,
    @Status bit
as begin
    begin try
        -- Sprawdzenie poprawności wpisywanych danych
        if not exists(select 1 from Employees where EmployeeID = @CoordinatorID and
                                                    PositionID = 4)
        begin
            throw 50001, 'Koordynator o danym ID nie istnieje lub nie jest kordynatorem kursów', 1;
        end

        if @Price < 0
        begin
            throw 50002, 'Cena nie może być mniejsza od 0', 1;
        end

        if @StartDate >= @EndDate
        begin
            throw 50003, 'Nie poprawnie wpisane daty', 1;
        end

        -- W innym przypadku możemy dodać
        -- Rezerwacja ID w produktach
        declare @NewProductID int;

        insert into Products (CategoryID, Status)
        values (2, @Status)

        -- Pobranie ID po dodaniu do produktów
        set @NewProductID = SCOPE_IDENTITY();

        -- Dodanie do tabeli ze Wbinarami
        insert Courses (CourseID, CoordinatorID, Name, Description, StartDate, EndDate, Price)
        values (@NewProductID, @CoordinatorID, @Name, @Description, @StartDate, @EndDate, @Price)

        print 'Poprawnie dodany kurs';
    end try
    begin catch
        -- Obsługa błedu
        print 'Pojawienie sie błedu: ' + error_message();
    end catch
end
go

