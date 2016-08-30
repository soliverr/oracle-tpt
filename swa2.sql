--------------------------------------------------------------------------------
--
-- File name:   swa2.sql
-- Purpose:     Display current users' session Wait info
--
-- Author:      Sergey Kryazhevskikh
-- Copyright:   (c) Public domain
--
-- Usage:       @swa2
--
--------------------------------------------------------------------------------

col s_sid  heading 'SID'                     format 999999
col s_mod  heading 'Application(Action)'     format a32
col s_prg  heading 'Program'                 format a48
col s_username heading 'DB:OS Username'      format a24
col s_let  heading 'Last  Call|elap. time'   format a10
col s_logt heading 'Logged in time'          format a14
col event  heading 'Wait Event'              format a32

select w.sid as s_sid,
       s.saddr,
       s.module||'('||s.action||')' as s_mod,
       s.program as s_prg,
       s.username || ':' || s.osuser as s_username,
       w.event,
       w.seconds_in_wait as seconds,
       w.state
 from v$session_wait w, v$session s
   where s.sid=w.sid 
         and w.event not in ('SQL*Net message from client',
                             'rdbms ipc message')
         and not exists ( select paddr from v$bgprocess where paddr = s.paddr )
 order by w.event, w.seconds_in_wait
/

