WITH sub1 as   ( -- sub1: one row per second, the resolution of SAMPLE_TIME     
     select
        sample_id,
        sample_time,
        sum(decode(session_state, 'ON CPU', 1, 0))  as on_cpu,
        sum(decode(session_state, 'WAITING', 1, 0)) as waiting,
        count(*) as active_sessions
     from
        v$active_session_history
     where
          sample_time between to_date('01-JUL-2016 10:01:00 AM','DD-MON-YYYY HH:MI:SS PM') 
        and to_date('01-JUL-2016 10:02:00 AM','DD-MON-YYYY HH:MI:SS PM') 
     group by
        sample_id,
        sample_time
      ) 
SELECT to_char(round(sub1.sample_time, 'MI'), 'YYYY-MM-DD HH24:MI') as sample_minute,
      'ON CPU',
      round(avg(sub1.on_cpu),1) as AAS
FROM sub1
group by
   round(sub1.sample_time, 'MI')
UNION ALL
SELECT to_char(round(sub1.sample_time, 'MI'), 'YYYY-MM-DD HH24:MI') as sample_minute,
      'WAITING',
      round(avg(sub1.WAITING),1) as AAS
FROM sub1
group by
   round(sub1.sample_time, 'MI')
order by
   1
;