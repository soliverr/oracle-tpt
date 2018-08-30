--------------------------------------------------------------------------------
--
-- File name:   aas-avail.sql
-- Purpose:     List available data to calculate Average Active Session
--
-- Author:      Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       List available snapshot for each DBID.
--              
--              This script lists all available intervals from dba_hist_snaphot table
--              
--              @aas-avail
--
--------------------------------------------------------------------------------

column db_name format a10
column instance_name format a10
column host_name format a16
column startup_time format a22

select a.dbid
     , b.db_name
     , b.instance_name
     , b.host_name
     , a.startup_time
     , to_char(min(a.begin_interval_time), 'DD.MM.YYYY') as begin_interval_time
     , to_char(max(a.end_interval_time), 'DD.MM.YYYY')   as end_interval_time
  from dba_hist_snapshot a
       inner join dba_hist_database_instance b
               on a.dbid = b.dbid
 group by a.dbid, b.db_name, b.instance_name, b.host_name, a.startup_time
 order by a.dbid desc, a.startup_time
;

