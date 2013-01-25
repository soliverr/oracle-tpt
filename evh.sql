COL evh_event HEAD WAIT_EVENT
COL wait_count_graph FOR A22
BREAK ON evh_event SKIP 1

SELECT
    event             evh_event 
  , wait_time_milli    
  , wait_count   
  , last_update_time   
fROM
    v$event_histogram
WHERE
    regexp_like(event, '&1', 'i')
ORDER BY
    event
  , wait_time_milli
/
