set serveroutput on;

begin
dbms_output.put_line('oy');

execute immediate ('truncate table z#_job_per_hr');

for i IN (
with s as (
select repeat_interval,job_name
--nvl(regexp_substr(substr(repeat_interval,(instr(upper(repeat_interval),'BYHOUR'))+7,length(repeat_interval)), '[^;]+;', 1, 1) 
,replace(regexp_substr(repeat_interval||';', '[^;]+;',instr(upper(repeat_interval),'BYHOUR'),1),';',',') hrly

from dba_scheduler_jobs 
where enabled='TRUE'
and upper(repeat_interval) like '%DAILY%'
and upper(repeat_interval) like '%BYHOUR%'
and repeat_interval not like '%BYMINUTE%'
)select * from s) loop

--dbms_output.put_line('hell9'||i.repeat_interval);

for j in (
select i.job_name,
regexp_substr(i.hrly,'(\d.*?)(,|$)',1,1, NULL, 1) HHR

from dual
where 1=1
connect by level <= regexp_count(i.hrly,',') ) loop

--dbms_output.put_line(j.job_name||','||j.hhr);
insert into z#_job_per_hr values (j.job_name,j.hhr);

end loop;

end loop;

insert into z#_job_per_hr
select job_name, to_char(start_date,'HH24') hhr
from dba_scheduler_jobs 
where enabled='TRUE'
and upper(repeat_interval) like '%DAILY%'
and upper(repeat_interval) not like '%BYHOUR%';

commit;

end;
