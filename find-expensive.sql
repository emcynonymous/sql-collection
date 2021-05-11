-- gets most expensive queries 
-- (by time spent, change "order by" to use another metric)
-- after a specific date
select
   sub.sql_id,
   sub.seconds_since_date,
   sub.execs_since_date,
   sub.gets_since_date
from
   ( -- sub to sort before rownum
     select
        sql_id,
        round(sum(elapsed_time_delta)/1000000) as seconds_since_date,
        sum(executions_delta) as execs_since_date,
        sum(buffer_gets_delta) as gets_since_date
     from
        dba_hist_snapshot natural join dba_hist_sqlstat
     where
        begin_interval_time > to_date('&&start_YYYYMMDD','YYYY-MM-DD')
     group by
        sql_id
     order by
        2 desc
   ) sub
where
   rownum < 30
;