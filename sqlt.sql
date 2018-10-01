--------------------------------------------------------------------------------
--
-- File name:   sqlt.sql
-- Purpose:     Search SQL by text substring
--
-- Author:      Tanel Poder
--              Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       List SQLs with given substring in it.
--              
--              This script lists SQL from V$SQL system view
--              
--              @sqlt some_sql_text
--
--------------------------------------------------------------------------------

column sql_id           format a17
column optimizer_mode   heading OPT_MODE format a17
column child_number     heading CHLD#
column sqlt_sql_text	heading SQL_TEXT format a100 word_wrap

select /* oradba-tpt */
        sql_id,
    	hash_value, 
--	      old_hash_value,
    	child_number, 
--	      plan_hash_value plan_hash, 
    	optimizer_mode,
	    sql_text sqlt_sql_text
  from 
       v$sql 
 where 
 	   lower(sql_text) like lower('%&1%')
   and sql_text not like '%/* oradba-tpt */%'    
/

