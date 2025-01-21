create function check_product_availability(
    @ProductID int
) returns bit
as begin
    -- 1 - produkt dostępy, 0 - produkt nie dostępny
    declare @Result bit = 0;

    -- Sprawdzenie statusu
    if (select Status from Products where ProductID = @ProductID) = 1
    begin
        set @Result = 1;
    end

    return @Result
end