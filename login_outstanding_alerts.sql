
col reason format a48
col alert_level format a10
col creation_time format a36

select decode(message_level, 5, 'WARNING', 1, 'CRITICAL') alert_level, creation_time, reason from dba_outstanding_alerts order by creation_time desc;