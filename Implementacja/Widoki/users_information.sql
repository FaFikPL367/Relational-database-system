create view users_information as
    select UserID,
           concat(FirstName, ' ', LastName) as fullName,
           Phone,
           Email,
           concat(Address, ' ,', City, ' ,', PostalCode) as fullAddress
    from Users;