--------------------------------------------------------------------------------
--
-- File name:   aas.sql
-- Purpose:     Calculate Average Active Session
--
-- Author:      Sergey Kryazhevskikh
-- Copyright:   (c) Public Domain
--
-- Usage:       Calculate average active session for current instance.
--              It may be supplied start and end time in form 'DD.MM.YYYY'
--
--              This script taken from "Historical Perfomance Analysis Using AWR'
--
--              @aas [start_time] [end_time]
--
--------------------------------------------------------------------------------

column pSec heading "AAS" format 999999.999

column 1 new_value 1
column 2 new_value 2
column b_time new_value start_time
column e_time new_value end_time

set feedback off
set termout off
-- Get parameters
select NULL "1", NULL "2" from dual where rownum = 0;
-- Set default values
select to_char(min(begin_interval_time), 'DD.MM.YYYY') b_time
     , to_char(max(end_interval_time), 'DD.MM.YYYY')   e_time
  from dba_hist_snapshot
;
set feedback on
set termout on

select to_char(end_interval_time,'DD.MM.YYYY HH24:MI') snap_time
     , instance_number
     , avg(v_ps) pSec
  from (
        select end_interval_time
             , instance_number
             , v/ela v_ps
          from (
                select round(s.end_interval_time,'hh24') end_interval_time
                     , s.instance_number
                     , (case when s.begin_interval_time = s.startup_time
                             then value
                             else value - lag(value,1) over (partition by sy.stat_id
                                                                        , sy.dbid
                                                                        , s.instance_number
                                                                        , s.startup_time
                                                                 order by sy.snap_id)
                        end)/1000000 v
                     , (cast(s.end_interval_time as date) - cast(s.begin_interval_time as date))*24*3600 ela
                  from dba_hist_snapshot s
                     , dba_hist_sys_time_model sy
                 where s.dbid = sy.dbid
                   and s.instance_number = sy.instance_number
                   and s.snap_id = sy.snap_id
                   and sy.stat_name = 'DB time'
                   and s.end_interval_time > to_date(nvl('&1', '&start_time'),'DD.MM.YYYY')
                   and s.end_interval_time < to_date(nvl('&2', '&end_time'),'DD.MM.YYYY') 
               )
       )
 group by to_char(end_interval_time,'DD.MM.YYYY HH24:MI'), instance_number
 order by to_char(end_interval_time,'DD.MM.YYYY HH24:MI'), instance_number
/

undefine 1 2 start_time end_time
