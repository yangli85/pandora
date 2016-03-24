set global event_scheduler =1;

DELIMITER $$
CREATE PROCEDURE update_designer_vip_status()
BEGIN
  update designers SET is_vip=false WHERE expired_at < now();
END$$
DELIMITER ;

create event if not exists update_designer_vip_status
on schedule every 1 DAY
do call update_designer_vip_status();