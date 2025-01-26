create function check_user_enrollment_for_product(
    @UserID int,
    @ProductID int
)
returns bit
as begin
    -- 1 - para istnieje, 0 - para nie istnieje
    declare @Result bit;

    -- Sprawdzenie, czy dana para istnieje
    if exists(select 1 from Users_Studies where UserID = @UserID and
                                                        StudiesID = @ProductID
       union select 1 from Users_Courses where UserID = @UserID and
                                                        CourseID = @ProductID
       union select 1 from Users_Webinars where UserID = @UserID and
                                                        WebinarID = @ProductID)
    begin
        set @Result = 1;
    end

    else
    begin
        set @Result = 0;
    end

    return @Result;
end