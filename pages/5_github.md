---
title: 5. GitHub
---

```sql github_date_bounds
select created_at::date as activity_date
from fct_github_commits
union all
select created_at::date as activity_date
from fct_github_pull_requests
```

```sql github_monthly_date_bounds
select created_at::date as activity_date
from fct_github_commits
where created_at::date >= '2023-01-01'
```

```sql repositories
select count(*) as repository_count
from dim_github_repositories
```

```sql commits
select count(*) as commit_count
from fct_github_commits
```

```sql pull_requests
select count(*) as pr_count
from fct_github_pull_requests
```

<BigValue 
  data={repositories} 
  value=repository_count
/>

<BigValue 
  data={commits} 
  value=commit_count
/>

<BigValue 
  data={pull_requests} 
  value=pr_count
/>

## Commits

```sql repository_list
with 

commits_by_repo as (

select 
    repo_full_name, 
    count(*) as commit_count
from fct_github_commits
group by 1

)

select 
    full_name as name, 
    created_at :: date as create_date, 
    updated_at as update_date,
    description, 
    language,
    commit_count
from dim_github_repositories 
left join commits_by_repo 
  on dim_github_repositories.full_name = commits_by_repo.repo_full_name
order by commit_count desc
```

<DataTable 
    data={repository_list}>
</DataTable>

<DateRange
  name=monthly_commit_dates
  data={github_monthly_date_bounds}
  dates=activity_date
  title="Commit date"
/>

```sql commits_monthly
select
    date_trunc('month', created_at) as date_month,
    count(*) as commit_count
from fct_github_commits
where created_at::date between '${inputs.monthly_commit_dates.start}' and '${inputs.monthly_commit_dates.end}'
group by 1
order by 1 
```

<BarChart 
    data={commits_monthly}
    x=date_month 
    y=commit_count 
/>

<DateRange
  name=repo_commit_dates
  data={github_monthly_date_bounds}
  dates=activity_date
  title="Commit date"
/>

```sql commits_monthly_by_repo
select
    (date_trunc('month', created_at)) :: varchar as date_month,
    replace(repo_full_name, 'davidwitk/', '') as repository_name,
    count(*) as commit_count
from fct_github_commits
where created_at::date between '${inputs.repo_commit_dates.start}' and '${inputs.repo_commit_dates.end}'
group by 1, 2
order by 1 desc, 2
```

<Heatmap 
    data={commits_monthly_by_repo} 
    x=repository_name 
    y=date_month 
    value=commit_count
    xLabelRotation=-90
    title="Commit Count"
    subtitle="By Repository"
    colorPalette={['white', 'maroon']} 
/>
