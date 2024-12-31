create view future_studies as
    select *
    from studie_information
    where getdate() < StartDate