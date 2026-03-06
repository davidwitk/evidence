---
title: 4. dbt Jobs
---

## Daily Total Runtime of Prod Run (Seconds)

```sql prod_run_daily
with base as (

select
    invocations.target_name,
    invocations.dbt_command,
    invocations.invocation_args,
    models.run_started_at,
    models.name,
    models.materialization,
    models.schema,
    models.total_node_runtime
from fct_dbt_model_executions as models
left join fct_dbt_invocations as invocations using (command_invocation_id)

)

select
    run_started_at :: date as date_day,
    count(distinct name) as model_count,
    count(*) as model_execution_count,
    sum(total_node_runtime) as total_runtime,
    sum(total_node_runtime) / count(*) :: decimal as avg_runtime
from base
group by all
```

<LineChart
  data={prod_run_daily}
  x=date_day
  y=total_runtime
/>

## Daily Average Model Runtime of Prod Run (Seconds)

<LineChart
  data={prod_run_daily}
  x=date_day
  y=avg_runtime
/>

## Weekly Runs by dbt Version
```sql run_weekly
select 
    date_week,
    dbt_version,
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


```sql latest_day
with 

base as (

select 
    models.run_started_at,
    invocations.target_name,
    invocations.dbt_command,
    models.name,
    models.materialization,
    models.schema,
    models.total_node_runtime
from fct_dbt_model_executions as models
left join fct_dbt_invocations as invocations using (command_invocation_id)

)

select
    name,
    schema,
    materialization,
    total_node_runtime
from base 
where run_started_at = (select max(run_started_at) from fct_dbt_model_executions)
order by total_node_runtime desc
```

<DataTable 
    data={latest_day}>
</DataTable>
