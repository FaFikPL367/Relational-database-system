CREATE INDEX Webinars_coordinatorID on Webinars (CoordinatorID);
CREATE INDEX Webinars_translatorID on Webinars (TranslatorID);
CREATE INDEX Webinars_languageID on Webinars (LanguageID);

create index Webinars_date on Webinars (DateAndBeginningTime, Duration)
