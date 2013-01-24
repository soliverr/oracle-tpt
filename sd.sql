set define on

col s_sid  heading 'Session'                 format a12
col s_user heading 'User|OS User@Machine'    format a26
col s_prog heading 'Program|(Module:Action)' format a40
col s_let  heading 'Last  Call|elap. time'   format a10
col s_logt heading 'Logged in time'          format a14
col s_prms heading 'Parameters'              format a32
col s_wait heading 'Seconds in wait'         format a32
col event                                    format a16
col server                                   format a8

select t1.sid||','||t1.serial# as s_sid, 
       sPID, 
       t1.USERNAME||'('||t1.osuser||'@'||machine||')' as s_user,
--       t1.schemaname,
       t1.PROGRAM||'('||t1.module||' '||t1.action||')' as s_prog, 
       status, 
       server,
--       nvl(t1.lockwait, 'None') lockwait, 
       to_char(to_date( '00:00:00', 'HH24:MI:SS' ) + numtodsinterval(last_call_et, 'second'), 'HH24:MI:SS') s_let,
       to_char(LOGON_TIME, 'dd.mm.yy hh24:mi') s_logt 
from v$session t1, v$process t2 
     where t1.paddr=t2.addr(+)
       and t1.sid in ( &1 )
order by status desc, s_let, s_user  desc;

select sid, count(1) from v$lock where sid in ( &1 ) group by sid;

select w.sid, 
       s.program||'('||s.module||' '||s.action||')' as s_prog,
       w.event,
       w.p1||' '||w.p2||' '||w.p3 as s_prms, 
--       w.p1raw,
--       w.p2raw,
--       w.wait_time, 
       w.seconds_in_wait||' '||w.state as s_wait
 from v$session_wait w, v$session s
   where s.sid=w.sid 
         and w.event <> 'SQL*Net message from client' 
         and w.event<>'rdbms ipc message'
         and s.sid in ( &1 )
 order by w.seconds_in_wait;

undef 1
