--------------------------------------------------------------------------------
--
-- File name:   sqlt_hist.sql
-- Purpose:     Search SQL by text substring in AWR
--
-- Author:      Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       List SQLs with given substring in it.
--              
--              This script lists SQL from DBA_HIST_SQLTEXT system view
--              
--              @sqlt_hist some_sql_text [dbid]
--
--------------------------------------------------------------------------------
column 1 new_value 1
column 2 new_value 2
column dbid new_value db_id

-- Get parameters
set feedback off
set termout off
select NULL "1", NULL "2" from dual where rownum = 0;
-- Set default values
select min(dbid) as dbid
  from dba_hist_snapshot
 group by dbid
;
set feedback on
set termout on


column sql_id           format a17
column optimizer_mode   heading OPT_MODE format a17
column sqlt_sql_text    heading SQL_TEXT format a100 word_wrap

select sql_id,
       optimizer_mode,
       sqlt_sql_text
from (
 select /* oradba-tpt */
        sql_id,
        row_number() over (partition by sql_id order by sql_id) as rn,
 --      plan_hash_value plan_hash,
        optimizer_mode,
        sql_text sqlt_sql_text
   from
        dba_hist_sqltext inner join dba_hist_sqlstat using (dbid,sql_id)
  where
        dbid = nvl('&2', &db_id)
    and lower(sql_text) like lower('%&1%')
    and sql_text not like '%/* oradba-tpt */%'
)
where rn = 1
/

