--------------------------------------------------------------------------------
--
-- File name:   saw.sql
-- Purpose:     Display Session Wait info for active user sessions
--
-- Author:      Kryazhevskikh Sergey, <soliverr@gmail.com>
-- Copyright:   
--
-- Usage:       @swm
--
--------------------------------------------------------------------------------

col s_sid  heading 'SID'                     format 999999
col s_mod  heading 'Application(Action)'     format a32
col s_info heading 'Program|(Module:Action)' format a32
col s_let  heading 'Last  Call|elap. time'   format a10
col s_logt heading 'Logged in time'          format a14
col sw_p1  head P1 for a18 justify left word_wrap
col sw_p2  head P2 for a18 justify left word_wrap
col sw_p3  head P3 for a18 justify left word_wrap
col event  head EVENT for a40 truncate

select w.sid as s_sid,
       s.saddr,
       s.module||'('||s.action||')' as s_mod,
       s.program,
       w.event,
       CASE w.state WHEN 'WAITING' THEN NVL2(w.p1text,w.p1text||'= ',null)||CASE WHEN w.p1 < 536870912 THEN to_char(w.p1) ELSE '0x'||rawtohex(w.p1raw) END ELSE null END SW_P1,
       CASE w.state WHEN 'WAITING' THEN NVL2(w.p2text,w.p2text||'= ',null)||CASE WHEN w.p2 < 536870912 THEN to_char(w.p2) ELSE '0x'||rawtohex(w.p2raw) END ELSE null END SW_P2,
       CASE w.state WHEN 'WAITING' THEN NVL2(w.p3text,w.p3text||'= ',null)||CASE WHEN w.p3 < 536870912 THEN to_char(w.p3) ELSE '0x'||rawtohex(w.p3raw) END ELSE null END SW_P3,
       w.seconds_in_wait as seconds
 from v$session_wait w, v$session s
   where s.sid=w.sid 
         and w.event <> 'SQL*Net message from client' 
         and w.event<>'rdbms ipc message'
         and not exists ( select paddr from v$bgprocess where paddr = s.paddr )
 order by w.event, w.seconds_in_wait
-- w.sid 
;
