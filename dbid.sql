--------------------------------------------------------------------------------
--
-- File name:   dbid.sql
-- Purpose:     List available databases in AWR history tables
--
-- Author:      Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       List available snapshot for each DBID in AWR history tables.
--
--              This script lists all available intervals from dba_hist_snaphot table
--
--              @dbid
--
--------------------------------------------------------------------------------

column db_name format a10
column instance_name format a10
column host_name format a16
column startup_time format a22
column begin_interval_time heading 'Start day' format a12
column snap_min heading 'Start snap' format 999999
column end_interval_time heading 'End day' format a12
column snap_max heading 'End snap' format 999999

select a.dbid
     , b.db_name
     , b.instance_name
     , b.host_name
     , a.startup_time
     , to_char(min(a.begin_interval_time), 'DD.MM.YYYY') as begin_interval_time
     , min(snap_id) as snap_min
     , to_char(max(a.end_interval_time), 'DD.MM.YYYY')   as end_interval_time
     , max(snap_id) as snap_max
  from dba_hist_snapshot a
       inner join dba_hist_database_instance b
               on a.dbid = b.dbid
 group by a.dbid, b.db_name, b.instance_name, b.host_name, a.startup_time
 order by a.dbid desc, a.startup_time
;

