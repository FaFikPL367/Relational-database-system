create view in_person_module_information as
    select ModuleID,
           Classroom,
           concat(FirstName, ' ', LastName) as Translator_full_name,
           LanguageName,
           Limit
    from In_person_Modules left join Translators on In_person_Modules.TranslatorID = Translators.TranslatorID
    left join Languages on In_person_Modules.LanguageID = Languages.LanguageID;