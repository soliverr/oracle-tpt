col du_MB head MB FOR 99999999.9
col owner format a24
select
    u.username owner
  , sum(nvl(s.bytes, 0))/1048576 du_MB
from
    dba_users u left join dba_segments s on (u.username = s.owner)
where
    lower(u.username) like lower('&1')
group by
    u.username
order by
    du_MB desc
/
