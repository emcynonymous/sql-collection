/** table/View comments --description */
select *
from dba_tab_comments 
where table_name=:table_name
--where 1=1
--and comments like '%PENTAHO%'
and owner=:owner_name;

	
/**TAble Structure**/
SELECT col1 
from(
SELECT '||COLUMN NAME||DATA TYPE||NOT NULL||COMMENTS||' col1,0 as column_id
FROM DUAL
UNION ALL
select '|'||dtc.COLUMN_NAME||'|'||DATA_TYPE|| decode(data_type,'DATE','','('||DATA_LENGTH||')')||'|'|| decode(nullable,'Y','False','True') ||'| '||dcc.comments|| '|' ,column_id
from dba_tab_columns dtc
join dba_col_comments dcc on (dtc.owner=dcc.owner and dtc.table_name=dcc.table_name and dcc.column_name=dtc.column_name)  
where 1=1
and dtc.owner=:owner_name
and dtc.table_name=upper(:table_name)
order by column_id)
union all
select '\\ _Roles That Has Access To This Table:_' from dual
union all
/**Roles**/
SELECT col1 FROM(
SELECT '||ROLE||PRIVILEGE||' col1 FROM DUAL
UNION ALL
SELECT '|' ||   role    ||  '|' ||  DECODE(REGEXP_COUNT (privs,','),8,'ALL',privs) || '|' privs
FROM ( select table_name, grantee role --, privilege
, listagg( privilege,',') within group (order by grantee) as privs
from dba_TAB_PRIVS a
where 1=1
and EXISTS (SELECT 1 FROM DBA_ROLES b WHERE a.grantee=b.role)
and table_name= upper(:table_name) --'SALES_DM_USER_POSITION_H' 
and owner=:owner_name --'DM_SALES'*/
group by table_name,grantee
))
UNION ALL
/**CONSTRAINTS**/
SELECT '\\ _Table Constraints_' FROM DUAL
UNION ALL
SELECT '||COLUMN NAME||CONSTRAINT NAME||CONSTRAINT TYPE||' col1 FROM DUAL
UNION ALL
select '|' || dcc.column_name  ||  '|' ||  dc.constraint_name  ||  '|' 
|| decode( dc.constraint_type,'P','Primary Key','U','Unique Key','C','Check Constraint',dc.constraint_type)  ||  '|'
--||  CAST (dc.search_condition AS CHAR(100)) ||'|'
from dba_constraints dc
--
join dba_cons_columns dcc
    ON dc.constraint_name=dcc.constraint_name
    AND dc.table_name=dcc.table_name
    AND dc.owner=dcc.owner
 --   
join dba_tab_columns dtc
    ON dc.table_name=dtc.table_name
    AND dcc.column_name=dtc.column_name
    AND dc.owner=dtc.owner
--    and dtc.nullable ='N'
--
where 1=1
and NOT (dc.constraint_type='C' and dtc.nullable='N')
and dc.table_name=:table_name
and dc.owner = :owner_name
UNION ALL
/**IndexES**/
SELECT '\\ _Indexes_' FROM DUAL
UNION ALL
SELECT '||INDEX NAME||INDEX TYPE||INDEXED COLUMN||' col1 FROM DUAL
UNION ALL
SELECT '|' || index_name || '|' || uniqueness || '|' || columns || '|'
FROM (
select parent.index_name, 
parent.uniqueness, 
listagg(child.column_name,', ') within group (order by column_position) columns
from dba_indexes parent
join dba_ind_columns child
on parent.owner=child.table_owner and parent.table_name=child.table_name
where 1=1
and parent.status='VALID'
and parent.table_name= :table_name --'SALES_DM_USER_POSITION_H' 
and parent.owner= :owner_name --'DM_SALES'
group by parent.index_name, parent.uniqueness);

/**INDEX**/
--SELECT index_name , uniqueness , columns 
--FROM (
select parent.index_name, 
parent.uniqueness, 
--listagg(child.column_name,', ') within group (order by column_position) columns
child.column_name
from dba_indexes parent
join dba_ind_columns child
on parent.owner=child.table_owner and parent.table_name=child.table_name
where 1=1
and parent.status='VALID'
and parent.table_name= :table_name --'SALES_DM_USER_POSITION_H' 
and parent.owner= :owner_name --'DM_SALES'
/
group by parent.index_name, parent.uniqueness);
