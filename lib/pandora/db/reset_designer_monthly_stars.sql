SET GLOBAL event_scheduler = ON;

DELIMITER $$
CREATE PROCEDURE reset_designer_monthly_stars()
BEGIN
  update designers SET monthly_stars=0;
END$$

create event if not exists reset_designer_monthly_stars on schedule every 1 MONTH do call reset_designer_monthly_stars();