SELECT DISTINCT a.sql_id,
                a.inst_id,
                a.blocking_session         blocker_ses,
                a.blocking_session_serial# blocker_ser,
                a.user_id,
                s.sql_text,
                a.module,
                a.sample_time
  FROM GV$ACTIVE_SESSION_HISTORY a, gv$sql s
 WHERE     a.sql_id = s.sql_id
       AND blocking_session IS NOT NULL
       AND a.user_id <> 0                                  -- exclude SYS user
       AND a.sample_time BETWEEN SYSDATE - 1 AND SYSDATE - 23 / 24;
