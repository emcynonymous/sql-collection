create table  z#_job_per_hr as
with  s as (
select owner,job_name,start_date,repeat_interval
--,instr(upper(repeat_interval),'BYHOUR'),
--,substr(repeat_interval,(instr(upper(repeat_interval),'BYHOUR'))+7,length(repeat_interval))
,case when (instr(upper(repeat_interval),'BYHOUR')) > 0 then
 nvl(regexp_substr(substr(repeat_interval,(instr(upper(repeat_interval),'BYHOUR'))+7,length(repeat_interval)), '[^;]+;', 1, 1)  ,
 substr(repeat_interval,(instr(upper(repeat_interval),'BYHOUR'))+7,length(repeat_interval)))
 else to_char(start_date,'HH24')
 end  as hourly

--,regexp_substr(repeat_interval, '[^;]+;', 1, 2) interval  -- INTERVAL=10;
--,regexp_substr(repeat_interval, '[^;]+;', 1, 3) interval  -- INTERVAL=10;

from dba_Scheduler_jobs 
where enabled='TRUE'
--and job_name='JOB_RUN_CLX_CALL_GENESYS'
and (upper(repeat_interval) like '%DAILY%'
or upper(Repeat_interval) like '%BYHOUR%'))
select * from s;
