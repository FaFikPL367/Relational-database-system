create view translators_information as
    select TranslatorID,
           concat(FirstName, ' ', LastName) as fullName,
           Phone,
           Email,
           concat(Address, ' ,', City, ' ,', PostalCode) as fullAddress
    from Translators;