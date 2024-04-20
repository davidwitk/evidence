---
title: 5. GitHub
---

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

```sql commits_monthly
select
    date_trunc('month', created_at) as date_month,
    count(*) as commit_count
from fct_github_commits
where date_month >= '2023-01-01'
group by 1
order by 1 
```

<BarChart 
    data={commits_monthly}
    x=date_month 
    y=commit_count 
/>

```sql commits_monthly_by_repo
select
    (date_trunc('month', created_at)) :: varchar as date_month,
    repository_name,
    count(*) as commit_count
from fct_github_commits
where date_month >= '2023-01-01'
group by 1, 2
--order by 1, 2
```

<!---
Deactivated as there seems to be a bug, the table is not rendered
<Heatmap 
    data={commits_monthly_by_repo} 
    x=repository_name 
    y=date_month 
    value=commit_count 
    xLabelRotation=-45
    colorPalette={['white', 'maroon']} 
    title="Commit Count"
    subtitle="By Repository"
    rightPadding=40
    cellHeight=25,
    legend=false
/>
-->


```sql repository_list
with 

commits_by_repo as (

select 
    repository_id, 
    count(*) as commit_count
from fct_github_commits
group by 1

)

select 
    name, 
    created_at :: date as create_date, 
    updated_at as update_date,
    description, 
    language,
    commit_count
from dim_github_repositories 
left join commits_by_repo using (repository_id)
order by commit_count desc
```

<DataTable 
    data={repository_list}>
</DataTable>
