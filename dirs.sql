--------------------------------------------------------------------------------
--
-- File name:   dirs.sql
-- Purpose:     List database directories
--
-- Author:      Sergey Kryazhevskikh, <soliverr@gmail.com>
-- Copyright:   (c) Public Domain
--
-- Usage:       List available directories in database.
--              
--              This script lists all available directories object 
--              from dba_directories table.
--              
--              @dirs
--
--------------------------------------------------------------------------------

column dirs_directory_path head DIRECTORY_PATH format a64
column directory_name format a32

select owner, directory_name, directory_path dirs_directory_path 
  from dba_directories
;
