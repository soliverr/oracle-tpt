--------------------------------------------------------------------------------
--
-- File name:   undo_seg.sql
--
-- Purpose:     Display undo segment information by segment id
--
-- Author:      Sergey Kryazhevskikh
-- Copyright:   
--
-- Usage:       @undo_seg <segment_id>
--              @undo_seg "select segment_id from dba_rollback_segs where segment_name = 'SEGMENT_NAME'"
--
--------------------------------------------------------------------------------

col segment_name format a30
col status       format a16

select d.segment_id, d.segment_name, d.owner, d.tablespace_name, d.status
       ,s.extents, s.xacts
  from dba_rollback_segs d
       left join v$rollstat s
              on (d.segment_id = s.usn)
 where segment_id in ( &1 )
;

/*
To check for any active transactions on a rollback segment:

SELECT KTUXEUSN, KTUXESLT, KTUXESQN, / Transaction ID /
KTUXESTA Status,
KTUXECFL Flags
FROM x$ktuxe
WHERE ktuxesta!='INACTIVE'
AND ktuxeusn=<SEGMENT_ID>
/
*/
