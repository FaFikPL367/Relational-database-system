create view future_studie_sign as
    select future_studies.StudiesID, count(UserID) as Total_users
    from future_studies inner join Users_Studies on Users_Studies.StudiesID = future_studies.StudiesID
    group by future_studies.StudiesID;