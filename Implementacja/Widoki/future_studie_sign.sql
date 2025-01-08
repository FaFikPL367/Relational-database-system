CREATE view future_studie_sign as
    select future_studies.StudiesID,
           Name,
           StartDate,
           EndDate,
           count(UserID) as Total_users
    from future_studies left join Users_Studies on Users_Studies.StudiesID = future_studies.StudiesID
    group by future_studies.StudiesID, Name, StartDate, EndDate;