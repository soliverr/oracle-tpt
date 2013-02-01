
prompt Show instance memory usage breakdown from v$sga_dynamic_components

col component format a32
col last_oper_type format a16
col last_oper_mode format a10
col current_size format 999G999G999G999
col min_size format 999G999G999G999
col max_size format 999G999G999G999
col user_specified_size format 999G999G999G999

select * from v$sga_dynamic_components;
