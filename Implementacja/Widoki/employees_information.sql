CREATE view employees_information as
    select EmployeeID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode,
           PositionName
    from Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID

