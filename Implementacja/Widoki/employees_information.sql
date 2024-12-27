create view employees_information as
    select EmployeeID,
           concat(FirstName, ' ', LastName) as fullname,
           Phone,
           Email,
           concat(Address, ' ,', City, ' ,', PostalCode) as fullAddress,
           PositionName
    from Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID