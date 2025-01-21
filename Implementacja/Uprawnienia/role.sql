-- ADMIN
create role admin;
grant all privileges on u_psosnows to admin;


-- DYREKTOR PLATFORMY
create role platform_director;
grant select on employees_information to platform_director;
grant select on future_course_sign to platform_director;
grant select on future_courses to platform_director;
grant select on future_studie_sign to platform_director;
grant select on future_studies to platform_director;
grant select on future_studie_sign to platform_director;
grant select on future_webinars to platform_director;
grant select on translators_information to platform_director;
grant select on users_information to platform_director;
grant execute on add_employee to platform_director;
grant execute on add_translator to platform_director;
grant execute on add_user to platform_director;


-- KOORDYNATOR WEBINARÓW
create role webinar_coordinator;
grant select on webinar_information to webinar_coordinator;
grant select on future_webinars to webinar_coordinator;
grant select on future_webinar_sign to webinar_coordinator;
grant select on translators_information to webinar_coordinator;
grant execute on add_webinar to webinar_coordinator;
grant execute on update_recordinglink_webinar to webinar_coordinator;


-- KOORDYNATOR STUDIÓW
create role studie_coordinator;
grant select on future_studies to studie_coordinator;
grant select on future_studie_sign to studie_coordinator;
grant select on employees_information to studie_coordinator;
grant select on studie_information to studie_coordinator;
grant select on translators_information to studie_coordinator;
grant execute on add_studie to studie_coordinator;
grant execute on add_reunion to studie_coordinator;
grant execute on add_meeting to studie_coordinator;
grant execute on add_meeting_async to studie_coordinator;
grant execute on add_meeting_in_person to studie_coordinator;
grant execute on add_meeting_sync to studie_coordinator;


-- KOORDYNATOR KURSÓW
create role course_coordinator;
grant select on course_information to course_coordinator;
grant select on employees_information to course_coordinator;
grant select on future_courses to course_coordinator;
grant select on future_course_sign to course_coordinator;
grant select on in_person_module_information to course_coordinator;
grant select on module_information to course_coordinator;
grant select on online_async_module_information to course_coordinator;
grant select on online_sync_module_information to course_coordinator;
grant select on translators_information to course_coordinator;
grant execute on add_course_modules to course_coordinator;
grant execute on add_course to course_coordinator;
grant execute on add_course_module_async to course_coordinator;
grant execute on add_course_module_in_person to course_coordinator;
grant execute on add_course_module_sync to course_coordinator;
grant execute on update_module_type to course_coordinator;
grant execute on update_recordinglink_module_sync to course_coordinator;


-- PRACOWNIK SEKRETARIATU
create role secretary;
grant select on users_information to secretary;
grant select on employees_information to secretary;
grant select on languages_count_translators to secretary;
grant select on translators_information to secretary;
grant select on translators_language to secretary;
grant execute on assign_translator_to_languages to secretary;
grant select on delete_language_from_translator to secretary;


-- WYKŁADOWCY





