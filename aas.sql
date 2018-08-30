--------------------------------------------------------------------------------
--
-- File name:   aas.sql
-- Purpose:     Calculate Average Active Session
--
-- Author:      Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       Calculate average active session for current instance.
--              It may be supplied start and end time in form 'DD.MM.YYYY'
--              
--              This script is taken from "Historical Perfomance Analysis Using AWR':
--                 AverageActiveSessions = DBTime / ElapsedTime
--              
--              @aas [dbid] [start_time] [end_time]
--
--------------------------------------------------------------------------------

column pSec heading "AAS" format 999999.999
column snap_list heading "Snap List" format a64

column 1 new_value 1
column 2 new_value 2
column 3 new_value 3
column b_time new_value start_time
column e_time new_value end_time
column dbid new_value db_id

set feedback off
set termout off
-- Get parameters
select NULL "1", NULL "2", NULL "3" from dual where rownum = 0;
-- Set default values
select dbid 
     , to_char(min(begin_interval_time), 'DD.MM.YYYY') b_time
     , to_char(max(end_interval_time), 'DD.MM.YYYY')   e_time
  from dba_hist_snapshot
 group by dbid 
 order by dbid desc
;
set feedback on
set termout on

select dbid
     , instance_number
     , to_char(end_interval_time,'DD.MM.YYYY HH24:MI') snap_time
     , avg(v_ps) pSec
     , listagg( snap_id, ',' ) within group (order by snap_id) as snap_list
  from (
        select end_interval_time
             , dbid
             , instance_number
             , snap_id
             , v/ela v_ps
          from (
                select round(s.end_interval_time,'hh24') end_interval_time
                     , sy.dbid
                     , s.instance_number
                     , s.snap_id
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
                   and s.end_interval_time > to_date(nvl('&2', '&start_time'),'DD.MM.YYYY')
                   and s.end_interval_time < to_date(nvl('&3', '&end_time'),'DD.MM.YYYY') 
                   and s.dbid = nvl('&1', &db_id)
               )
       )
 group by dbid, instance_number, to_char(end_interval_time,'DD.MM.YYYY HH24:MI')
 order by dbid, instance_number, to_char(end_interval_time,'DD.MM.YYYY HH24:MI')
/

undefine 1 2 3 start_time end_time db_id
