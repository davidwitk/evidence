select 
    *,
    dbt_custom_envs like '%"DBT_CLOUD_JOB_ID": "193204"%' as is_main_job, -- as JSON extension is not supported by Evidence, we use pattern matching for now
    date_trunc('week', run_started_at :: timestamp) as date_week
from prod.analytics.fct_dbt_invocations
