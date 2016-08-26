--------------------------------------------------------------------------------
--
-- File name:   dir.sql
-- Purpose:     List content of the script temporary directory
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--
-- Usage:       @dir [file_regexp]
--
--------------------------------------------------------------------------------

column 1 new_value 1

set feedback off
set termout off
-- Get parameters
select NULL "1" from dual where rownum = 0;
set feedback on
set termout on

prompt
prompt Files in &TPT_TEMP directory
prompt

host ls -l &TPT_TEMP/&&1

undefine 1
