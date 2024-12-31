create view future_webinar_sign as
    select future_webinars.WebinarID, count(UserID) as Total_users
    from future_webinars inner join Users_Webinars on Users_Webinars.WebinarID = future_webinars.WebinarID
    group by future_webinars.WebinarID;