# Role - PS

## Admin
```SQL
create role admin;
grant execute on update_recordinglink_webinar to admin;
grant select, lock tables, show databases, reload, file on *.* to admin;
```

---

## Dyrektor platformy
```SQL
create role platform_director;
grant select on employees_information to platform_director;
grant select on future_course_sign to platform_director;
grant select on future_courses to platform_director;
grant select on future_studie_sign to platform_director;
grant select on future_studies to platform_director;
grant select on future_studie_sign to platform_director;
grant select on future_webinars to platform_director;
grant select on future_meetings to platform_director;
grant select on future_meetings_sign to platform_director;
grant select on translators_information to platform_director;
grant select on users_information to platform_director;
grant select on dont_make_payment_in_time to platform_director;
grant select on dont_make_payment_in_time_reunion to platform_director;
grant select on financial_report to platform_director;
grant select on financial_report_courses to platform_director;
grant select on financial_report_meetings to platform_director;
grant select on financial_report_studies to platform_director;
grant select on financial_report_webinar to platform_director;
grant select on extended_payments to platform_director;
grant select on products_orders to platform_director;
grant select on users_orders_count to platform_director;
grant execute on add_employee to platform_director;
grant execute on add_translator to platform_director;
grant execute on add_user to platform_director;
grant execute on set_extended_payment_deadline to platform_director;
grant execute on delete_user_from_product to platform_director;
```

---

## Koordynator webinarów
```SQL
create role webinar_coordinator;
grant select on webinar_information to webinar_coordinator;
grant select on future_webinars to webinar_coordinator;
grant select on future_webinar_sign to webinar_coordinator;
grant select on translators_information to webinar_coordinator;
grant execute on add_webinar to webinar_coordinator;
grant execute on update_recordinglink_webinar to webinar_coordinator;
grant execute on delete_user_from_product to webinar_coordinator;
```

---

## Koordynator studiów
```SQL
create role studie_coordinator;
grant select on future_studies to studie_coordinator;
grant select on future_studie_sign to studie_coordinator;
grant select on employees_information to studie_coordinator;
grant select on studie_information to studie_coordinator;
grant select on studies_sign_limit to studie_coordinator;
grant select on translators_information to studie_coordinator;
grant select on future_meetings to studie_coordinator;
grant select on future_meetings_sing to studie_coordinator;
grant select on meeting_sign_limit to studie_coordinator;
grant select on meetings_information to studie_coordinator;
grant select on in_person_meeting_information to studie_coordinator;
grant select on online_async_meeting_information to studie_coordinator;
grant select on online_sync_meeting_information to studie_coordinator;
grant select on reunion_information to studie_coordinator;
grant select on studies_practice_attendance to studie_coordinator;
grant select on studies_meetings_list to studie_coordinator;
grant execute on add_studie to studie_coordinator;
grant execute on add_reunion to studie_coordinator;
grant execute on add_meeting to studie_coordinator;
grant execute on add_meeting_async to studie_coordinator;
grant execute on add_meeting_in_person to studie_coordinator;
grant execute on add_meeting_sync to studie_coordinator;
grant execute on delete_user_from_product to studie_coordinator;
grant execute on add_practice to studie_coordinator;
grant execute on add_subject to studie_coordinator;
grant execute on assign_user_to_practice to studie_coordinator;
grant execute on set_student_grade to studie_coordinator;
grant execute on set_student_practice_attendance to studie_coordinator;
grant execute on update_recordinglink_meeting_sync to studie_coordinator;
grant execute on update_meeting_type to studie_coordinator;
```

---

## Koordynator kursów
```SQL
create role course_coordinator;
grant select on course_information to course_coordinator;
grant select on course_sign_limit to course_coordinator;
grant select on employees_information to course_coordinator;
grant select on future_courses to course_coordinator;
grant select on future_course_sign to course_coordinator;
grant select on in_person_module_information to course_coordinator;
grant select on module_information to course_coordinator;
grant select on online_async_module_information to course_coordinator;
grant select on online_sync_module_information to course_coordinator;
grant select on translators_information to course_coordinator;
grant select on course_passes to course_coordinator;
grant execute on add_course_modules to course_coordinator;
grant execute on add_course to course_coordinator;
grant execute on add_course_module_async to course_coordinator;
grant execute on add_course_module_in_person to course_coordinator;
grant execute on add_course_module_sync to course_coordinator;
grant execute on update_module_type to course_coordinator;
grant execute on update_recordinglink_module_sync to course_coordinator;
grant execute on set_user_module_passes to course_coordinator;
```

---

## Pracownik Sekretariatu
```SQL
create role secretary;
grant select on users_information to secretary;
grant select on employees_information to secretary;
grant select on languages_count_translators to secretary;
grant select on translators_information to secretary;
grant select on translators_language to secretary;
grant execute on assign_translator_to_languages to secretary;
grant select on delete_language_from_translator to secretary;
grant select on financial_report to secretary;
grant select on financial_report_webinar to secretary;
grant select on financial_report_studies to secretary;
grant select on financial_report_meetings to secretary;
grant select on financial_report_courses to secretary;
grant select on extended_payments to secretary;
grant select on products_orders to secretary;
grant select on dont_make_payment_in_time_reunion to secretary;
grant select on dont_make_payment_in_time to secretary;
```

---

## Wykładowca
```SQl
create role lecturer;
grant select on meeting_sign_limit to lecturer;
grant select on course_sign_limit to lecturer;
grant select on studie_sign_limit to lecturer;
grant select on studies_meetings_list to lecturer;
grant execute on set_student_meeting_attendance to lecturer;
grant execute on set_user_module_passes to lecturer;
```

---

## Translator
```SQL
create role translator;
grant select on meetings_information to translator;
grant select on in_person_module_information to translator;
grant select on online_sync_module_information to translator;
grant select on module_information to translator;
```

---

## Użytkownik
```SQL
create role user;
grant select on webinar_information to user;
grant select on course_information to user;
grant select on studie_information to user;
grant select on meetings_information to user;
grant select on ourse_module_types to user;
grant select on future_course to user;
grant select on future_webinars to user;
grant select on future_studies to user;
grant select on future_meetings to user;
grant select on in_person_meeting_information to user;
grant select on in_person_module_information to user;
grant select on online_sync_meeting_information to user;
grant select on online_async_meeting_information to user;
grant select on online_sync_module_information to user;
grant select on online_async_module_information to user;
grant select on reunion_information to user;
```