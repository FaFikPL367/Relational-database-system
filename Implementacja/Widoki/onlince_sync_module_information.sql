create view online_sync_module_information as
    select ModuleID,
           MeetingLink,
           RecordingLink,
           concat(FirstName, ' ', LastName) as Translator_full_name,
           LanguageName
    from Online_Sync_Modules inner join Translators on Online_Sync_Modules.TranslatorID = Translators.TranslatorID
    inner join Languages on Online_Sync_Modules.LanguageID = Languages.LanguageID;