---
title: "3. Database Monitoring"
---

# Postgres Data Warehouse

```sql latest_day
select 
    sum(size_in_mb) as size_in_mb,
    count(distinct schema_name) as schema_count,
    count(distinct table_id) as table_count,
    sum(row_count) as row_count,
    sum(column_count) as column_count
from fct_postgres_tables_daily
where date_day = (select max(date_day) from fct_postgres_tables_daily)
```

<BigValue 
  data={latest_day} 
  value=size_in_mb
/>

<BigValue 
  data={latest_day} 
  value=schema_count
/>

<BigValue 
  data={latest_day} 
  value=table_count
/>

<BigValue 
  data={latest_day} 
  value=row_count
/>

<BigValue 
  data={latest_day} 
  value=column_count
/>

## Used Disk Space (MB) by Day

```sql by_day
select 
    date_day,
    sum(size_in_mb) as size_in_mb
from fct_postgres_tables_daily
group by 1
order by 1
```

<LineChart
  data={by_day}
  x=date_day
  y=size_in_mb
/>

```sql largest_schemas
select 
    schema_name,
    sum(size_in_mb) as size_in_mb 
from fct_postgres_tables_daily
where date_day = (select max(date_day) from fct_postgres_tables_daily)
group by 1
order by 2 desc
```

## Largest Schemas

<BarChart 
    data={largest_schemas}
    x=schema_name 
    y=size_in_mb 
    swapXY=true
/>

```sql largest_tables
select 
    schema_name,
    table_name,
    size_in_mb,
    row_count,
    column_count
from fct_postgres_tables_daily
where date_day = (select max(date_day) from fct_postgres_tables_daily)
order by 3 desc
```

## Largest Tables

<DataTable 
    data={largest_tables}>
</DataTable>

# Nextcloud

## Nextcloud Used Disk Space

```sql nextcloud_disk_space
select * from fct_nextcloud_disk_space
order by 1, 2
```

<LineChart
  data={nextcloud_disk_space}
  x=date_day
  y=size_used_percentage
  series=mount_path
/>
