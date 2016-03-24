set global event_scheduler =1;

DELIMITER $$
CREATE PROCEDURE reset_designer_weekly_stars()
BEGIN
  update designers SET weekly_stars=0;
END$$
DELIMITER ;

create event if not exists reset_designer_weekly_stars
on schedule every 1 WEEK
do call reset_designer_weekly_stars();