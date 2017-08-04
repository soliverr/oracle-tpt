--------------------------------------------------------------------------------
--
-- File name:   df.sql
-- Purpose:     Show Oracle tablespace free space in Unix df style
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--
-- Usage:       @df
--
--------------------------------------------------------------------------------

col "% Used" for a6
col "Used" for a22

select tablespace_name
      ,t_mb "TotalMB"
      ,t_mb - f_mb "UsedMB"
      ,f_mb "FreeMB"
      ,lpad(ceil((1 - f_mb / decode(t_mb, 0, 1, t_mb)) * 100) || '%', 6) "% Used"
      ,t_ext "Ext"
      ,'|' || rpad(lpad('#', ceil((1 - f_mb / decode(t_mb, 0, 1, t_mb)) * 20), '#'), 20, ' ') || '|' "Used"
from (
select t.tablespace_name as tablespace_name,
       t.maxmb,
       t.mb,
       case when t.ext = 'YES' then nvl(t.maxmb, nvl(t.mb, 0))
            else nvl(t.mb, 0)
       end as t_mb,
       nvl(f.mb,0) as f_mb,
       t.ext as t_ext
from (
  select tablespace_name, trunc(sum(bytes)/1048576) MB
  from dba_free_space
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes_free)/1048576) MB
  from v$temp_space_header
  group by tablespace_name
) f, (
  select tablespace_name, trunc(sum(bytes)/1048576) MB, trunc(sum(maxbytes)/1048576) MaxMB, max(autoextensible) ext
  from dba_data_files
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes)/1048576) MB, trunc(sum(maxbytes)/1048576) MaxMB, max(autoextensible) ext
  from dba_temp_files
  group by tablespace_name
) t
where t.tablespace_name = f.tablespace_name (+)
)
order by tablespace_name;

