create index Studies_coordinatorID on Studies (CoordinatorID);
create index idx_studies_startdate on Studies (StartDate);
create index idx_studies_enddate on Studies (EndDate);
create index idx_studies_totaldate on Studies (StartDate, EndDate)