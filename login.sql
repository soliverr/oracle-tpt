-- calling init.sql which will set up sqlpus variables
@@login_init.sql
-- calling format.sql which will format some usefull columns
@@login_format.sql
-- i.sql is the "who am i" script which shows your session/instance info and 
-- also sets command prompt window/xterm title
@@i.sql
--
@@login_outstanding_alerts.sql

undefine 1 2 3 4 5 6 7 8 9
