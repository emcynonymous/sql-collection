To create graphs in SQL Developer:

 

Go to Reports Tab

Right click on “User Defined Reports”, then “New Report”

Enter “Name” for report name

Change Style to “Chart”

Paste SQL in the SQL text field

On the left side, click “Property”, change the Chart Type to “Bar – Vertical Stack”

Then “Apply”

 

 

For SQL Dev

-- AAS by Wait Class (modified date format to use YYYY instead of YY)

select to_char(end_time,'mm-dd-yyyy hh24') snap_time
, wait_class
, sum(pSec) avg_sess
from
(select end_time
, wait_class
, p_tmfg/1000000/ela pSec
from (
select round(s.end_interval_time,'hh24') end_time
, (cast(s.end_interval_time as date) - cast(s.begin_interval_time as date))*24*3600 ela
, s.snap_id
, wait_class
, e.event_name
, case when s.begin_interval_time = s.startup_time
then e.time_waited_micro_fg
else e.time_waited_micro_fg
- lag(time_waited_micro_fg) over (partition by event_id
, e.dbid
, e.instance_number
, s.startup_time
order by e.snap_id)
end p_tmfg
from dba_hist_snapshot s
, dba_hist_system_event e
where s.dbid = e.dbid
and s.instance_number = e.instance_number
and s.snap_id = e.snap_id
and s.end_interval_time > to_date(:start_date,'MMDDYYYY ')
and s.end_interval_time < to_date(:end_date,'MMDDYYYY')
and e.wait_class != 'Idle'
union all
select trunc(s.end_interval_time,'hh24') end_time
, (cast(s.end_interval_time as date) - cast(s.begin_interval_time as date))*24*3600 ela
, s.snap_id
, t.stat_name wait_class
, t.stat_name event_name
, case when s.begin_interval_time = s.startup_time
then t.value
else t.value
- lag(value) over (partition by stat_id
, t.dbid
, t.instance_number
, s.startup_time
order by t.snap_id)
end p_tmfg
from dba_hist_snapshot s
, dba_hist_sys_time_model t
where s.dbid = t.dbid
and s.instance_number = t.instance_number
and s.snap_id = t.snap_id
and s.end_interval_time > to_date(:start_date,'MMDDYYYY')
and s.end_interval_time < to_date(:end_date,'MMDDYYYY')
and t.stat_name = 'DB CPU'))
group by to_char(end_time,'mm-dd-yyyy hh24'), wait_class
order by to_date(to_char(end_time,'mm-dd-yyyy hh24'),'mm-dd-yyyy hh24'), wait_class

 

 

--AAS by Wait Class (10g) modified query to be used by

 

select to_char(end_time,'mm-dd-yyyy hh24') snap_time
, wait_class
, sum(pSec) avg_sess
from
(select end_time
, wait_class
, p_tmfg/1000000/ela pSec
from (
select round(s.end_interval_time,'hh24') end_time
, (cast(s.end_interval_time as date) - cast(s.begin_interval_time as date))*24*3600 ela
, s.snap_id
, wait_class
, e.event_name
, case when s.begin_interval_time = s.startup_time
then e.time_waited_micro
else e.time_waited_micro
- lag(time_waited_micro) over (partition by event_id
, e.dbid
, e.instance_number
, s.startup_time
order by e.snap_id)
end p_tmfg
from dba_hist_snapshot s
, dba_hist_system_event e
where s.dbid = e.dbid
and s.instance_number = e.instance_number
and s.snap_id = e.snap_id
and s.end_interval_time > to_date(:start_date,'MMDDYYYY')
and s.end_interval_time < to_date(:end_date,'MMDDYYYY')
and e.wait_class != 'Idle'
union all
select trunc(s.end_interval_time,'hh24') end_time
, (cast(s.end_interval_time as date) - cast(s.begin_interval_time as date))*24*3600 ela
, s.snap_id
, t.stat_name wait_class
, t.stat_name event_name
, case when s.begin_interval_time = s.startup_time
then t.value
else t.value
- lag(value) over (partition by stat_id
, t.dbid
, t.instance_number
, s.startup_time
order by t.snap_id)
end p_tmfg
from dba_hist_snapshot s
, dba_hist_sys_time_model t
where s.dbid = t.dbid
and s.instance_number = t.instance_number
and s.snap_id = t.snap_id
and s.end_interval_time > to_date(:start_date,'MMDDYYYY')
and s.end_interval_time < to_date(:end_date,'MMDDYYYY')
and t.stat_name = 'DB CPU'))
group by to_char(end_time,'mm-dd-yyyy hh24'), wait_class
order by to_date(to_char(end_time,'mm-dd-yyyy hh24'),'mm-dd-yyyy hh24'), wait_class;

 

 

--SQL Elapsed Time per Execution

 

select to_char(round(end_interval_time,'hh24'),'mm-dd-yyyy hh24') snap_time
, sql_id
, sum(elapsed_time_delta/1000000)/decode(sum(executions_delta),0,null,sum(executions_delta))
avg_elapsed
from dba_hist_sqlstat sq
, dba_hist_snapshot s
where sq.sql_id (+) = :sql_id
and sq.dbid (+) = s.dbid
and sq.instance_number (+) = s.instance_number
and sq.snap_id (+) = s.snap_id
and s.end_interval_time > to_date(:start_date,'MMDDYYYY')
and s.end_interval_time < to_date(:end_date,'MMDDYYYY')
group by to_char(round(end_interval_time,'hh24'),'mm-dd-yyyy hh24'), sql_id
order by to_date(to_char(round(end_interval_time,'hh24'),'mm-dd-yyyy hh24'),'mm-dd-yyyy hh24')
 

-- AAS per minute

WITH sub1 as   (
     select
        sample_id,
        sample_time,
        sum(decode(session_state, 'ON CPU', 1, 0))  as on_cpu,
        sum(decode(session_state, 'WAITING', 1, 0)) as waiting,
        count(*) as active_sessions
     from
        v$active_session_history
     where 1=1
       -- and  sample_time between to_date('01-JUL-2016 10:01:00 AM','DD-MON-YYYY HH:MI:SS PM')
      --  and to_date('01-JUL-2016 10:02:00 AM','DD-MON-YYYY HH:MI:SS PM')
      and sample_time > sysdate - (:minutes/1440)
     group by
        sample_id,
        sample_time
      )

SELECT to_char(round(sub1.sample_time, 'MI'), 'YYYY-MM-DD HH24:MI') as sample_minute,
      'ON CPU' "STATE",
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


######################################################

 

--(you can save this one as TABLE report – not a graph)
--AWR_plan_changes (SQL Elapsed time over time with plan hash value)

 

set lines 155
col execs for 999,999,999
col avg_etime for 999,999.999
col avg_lio for 999,999,999.9
col begin_interval_time for a30
col node for 99999
break on plan_hash_value on startup_time skip 1

select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id = nvl('&sql_id','4dqs2k5tynk61')
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and executions_delta > 0
order by 1, 2, 3