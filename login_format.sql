--
-- Page output
set pagesize 0


-- Defines
-- - Use this editor
define _EDITOR=vim

-- - command prompt
-- SET SQLPROMPT '&_USER.@&_CONNECT_IDENTIFIER.> '
undefine usr db
col usr new_value usr
col db  new_value db
col sid new_value sid
set termout off
select lower(user) usr, 
--       lower(substr(global_name, 1, instr(global_name, '.')-1)) db
       lower(global_name) db
 from  global_name
/
select ltrim(sid) sid from v$mystat
/
set termout on
set sqlprompt '&&usr:&&sid.@&&db.> '

-- Output formatting
set serveroutput on size 20000
set linesize 256
set pagesize 35
set time on
set timing on
set long 2048

-- Columns formatting
col spid format a8
col parameter format a32
col value format a48
col type format a32
col owner format a12
col db_link format a16
col username format a16
col host format a16
col event format a32
col db_link format a16
col tablespace_name format a24
col segment_name format a40
col object_type format a20 
col object_name format a32
col table_name format a26
col comments format a40
col machine format a16
col program format a16
col last_call_et format a10
col state format a17
col module format a24
col action format a24
col file_name format a52
col member format a64


-- dba_jobs
col log_user format a10
col this_date format a16
col this_sec format a16
col next_date format a16
col next_sec format a16
col last_date format a16
col last_sec format a16
col interval format a16
col priv_user format a10
col schema_user format a10
col what format a40

-- dba_constraints
col constraint_name format a30
col status format a9
col r_owner format a10
col r_constraint_name format a32

-- dba_rule_sets
col rule_set_owner format a16
col rule_set_name format a24

-- dba_profiles
col profile format a16
col resource_name format a32
col resource_type format a8
col limit  format a16

-- _indexes
col index_name format a16
col index_type format a8
col table_type format a8
col uniquness format a8
col include_column format a24

-- snapshot
col mview_name format a32
col rowner format a10
col rname format a16
col snapshot_id FORMAT b9999999999
col snapshot_site format a26
col current_snapshots format a21
col name format a32
col master format a48
col oldest_pk format a19
col youngest format a19

col sql_text format a48
col logon_time format a16
col osuser format a8

col FIRST_CHANGE#       format 999g999g999g999g999
col NEXT_CHANGE#        format 999g999g999g999g999
col CONTROLFILE_CHANGE# format 999g999g999g999g999
col ARCHIVELOG_CHANGE#  format 999g999g999g999g999

col comp_name format a48
col version format a16

-- Show instance status
col status_string format a128
select INSTANCE_NAME||' '||HOST_NAME||' '||VERSION||' '||-
       INSTANCE_ROLE||' '||STATUS||' '||DATABASE_STATUS||-
       ' '||ACTIVE_STATE||' '||LOGINS||-
       ' since '||to_char(STARTUP_TIME, 'DD.MM.RR HH24:MI:SS') as status_string 
 from  v$instance;

