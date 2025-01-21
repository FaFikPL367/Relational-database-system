create function check_product_availability(
    @ProductID int
) returns bit
as begin
    declare @Result bit = 0;

    -- Sprawdzenie, czy istnieje produkt o danym ID

    declare @tmpProducts table
    (
        ProductID int,
        Status    bit
    )
    insert @tmpProducts
    select ProductID, Status
    from Products
    where Products.ProductID = @ProductID;

    if not exists(select 1 from @tmpProducts)
       begin
            throw 50001, 'Produkt o podanym ID nie istnieje', 1
        end
    set @Result = (select 2 from @tmpProducts)
    return @Result
end