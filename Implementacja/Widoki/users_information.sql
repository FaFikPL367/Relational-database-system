CREATE view users_information as
    select UserID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode
    from Users;