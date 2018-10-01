--------------------------------------------------------------------------------
--
-- File name:   du_tmp.sql
--
-- Purpose:     Temporary usage
--
-- Author:      Kryazhevskikh Sergey, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       @du_tmp <sid>
--              @s 52,110,225
--              @s "select sid from v$session where username = 'XYZ'"
--              @s &mysid
--
--------------------------------------------------------------------------------

column tablespace format a16
column osuser format a16
column s_let  heading 'Last  Call|elap. time'   format a10
column sql_id                                   format a16

column 1 new_value 1
column l_sql_sid new_value l_sql
set feedback off
set termout off
-- Get parameters
select NULL "1" from dual where rownum = 0;
select 'select sid from v$session' l_sql_sid from dual;
set feedback on
set termout on

-- FIXME: how to pass value from &1
define 1 = "&l_sql"


SELECT   
         a.sid
       , a.serial#
       , a.username
       , b.tablespace
       , round (((sum(b.blocks * p.VALUE ) / 1024 / 1024)), 2) size_mb
       , b.sql_id
       , a.osuser
       , a.program
       , a.status
       , to_char(to_date( '00:00:00', 'HH24:MI:SS' ) + numtodsinterval(a.last_call_et, 'second'), 'HH24:MI:SS') s_let
    FROM v$session a
       , v$sort_usage b
       , v$process c
       , v$parameter p
   WHERE p.NAME = 'db_block_size'
     AND a.saddr = b.session_addr
     AND a.paddr = c.addr
     AND a.sid in ( &1 )
group by b.tablespace, a.sid, a.serial#, a.username, a.osuser, a.program, a.status, a.last_call_et, b.sql_id     
order by round (((sum(b.blocks * p.VALUE ) / 1024 / 1024)), 2) , b.tablespace, a.username
;

undefine 1
