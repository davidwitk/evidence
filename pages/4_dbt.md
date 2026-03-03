---
title: 4. dbt Jobs
---

## Daily Total Runtime of Prod Run

```sql prod_run_daily
with base as (

select
    models.source,
    models.run_started_at,
    models.name,
    models.materialization,
    models.schema,
    models.total_node_runtime,
    invocations.dbt_cloud_run_reason,
    invocations.is_main_job,
    case
       when (invocations.dbt_cloud_run_reason = 'scheduled' and invocations.is_main_job and models.run_started_at > '2023-10-13') or invocations.target_name = 'prod_duckdb' then true
       else false
    end as is_prod_job
from fct_dbt_model_executions as models
left join fct_dbt_invocations as invocations using (command_invocation_id)

)

select
    run_started_at :: date as date_day,
    source,
    count(*) as model_count,
    sum(total_node_runtime) as total_runtime,
    sum(total_node_runtime) / count(*) :: decimal as avg_runtime
from base
where is_prod_job
group by all
```

<LineChart
  data={prod_run_daily}
  x=date_day
  y=total_runtime
  series=source
/>

## Daily Average Model Runtime of Prod Run

<LineChart
  data={prod_run_daily}
  x=date_day
  y=avg_runtime
  series=source
/>

## Weekly Runs by dbt Version
```sql run_weekly
select 
    date_week,
    source || ' - ' || dbt_version as dbt_version,
    count(*) as run_count
from fct_dbt_invocations
group by 1, 2
order by 1, 2 asc
```

<BarChart 
    data={run_weekly}
    x=date_week 
    y=run_count 
    series=dbt_version
/>

## Weekly Runs by Trigger
```sql run_trigger_weekly
select 
    date_week, 
    case
       when dbt_cloud_run_reason = 'Kicked off from UI by david.witkowski@posteo.net' then 'Manual Trigger in dbt Cloud'
       when dbt_cloud_run_reason = 'scheduled' then 'Scheduled'
       when dbt_cloud_run_reason = '' then 'Manual Trigger in Local Env'
    end as run_reason,
    count(*) as run_count
from fct_dbt_invocations
group by 1, 2
order by 1, 2
```

<BarChart 
    data={run_trigger_weekly}
    x=date_week 
    y=run_count 
    series=run_reason
/>


```sql latest_day
with 

base as (

select 
    models.run_started_at,
    models.name,
    models.materialization,
    models.schema,
    models.total_node_runtime,
    invocations.dbt_cloud_run_reason,
    invocations.is_main_job,
    case
       when (invocations.dbt_cloud_run_reason = 'scheduled' and invocations.is_main_job and models.run_started_at > '2023-10-13') or invocations.target_name = 'prod_duckdb' then true
       else false
    end as is_prod_job
from fct_dbt_model_executions as models
left join fct_dbt_invocations as invocations using (command_invocation_id)

),

filter_prod_job as (

select * 
from base 
where is_prod_job

)

select 
    schema, 
    name,
    materialization,
    total_node_runtime
from filter_prod_job 
where run_started_at >= date_add(current_date, - interval 1 day)
order by 4 desc
```

<DataTable 
    data={latest_day}>
</DataTable>


## Number of Models in a Run by Materialization Type (Last 60 Days)

```sql run_materialiation_daily
with 

base as (

select 
    models.run_started_at,
    models.name,
    models.materialization,
    models.schema,
    models.total_node_runtime,
    invocations.dbt_cloud_run_reason,
    invocations.is_main_job,
    case
       when (invocations.dbt_cloud_run_reason = 'scheduled' and invocations.is_main_job and models.run_started_at > '2023-10-13') or invocations.target_name = 'prod_duckdb' then true
       else false
    end as is_prod_job
from fct_dbt_model_executions as models
left join fct_dbt_invocations as invocations using (command_invocation_id)

),

filter_prod_job as (

select * 
from base 
where 
    is_prod_job
    and run_started_at >= date_add(current_date, - interval 60 day)

)

select 
    run_started_at :: date as date_day,
    materialization,
    count(*) as model_count
from filter_prod_job 
group by 1, 2
order by 1, 2
```

<BarChart 
    data={run_materialiation_daily}
    x=date_day 
    y=model_count 
    series=materialization
/>
