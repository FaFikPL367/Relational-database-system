CREATE view translators_information as
    select TranslatorID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode
    from Translators;