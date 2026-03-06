---
title: 3. Data Lake Monitoring
---

# S3 Data Lake

```sql latest_day
select 
    round(sum(size_mb), 2) as size_mb,
    count(distinct folder_level_1) as folder_level_1_count,
    count(*) as file_count
from fact_s3_file_inventory
where extracted_date = (select max(extracted_date) from fact_s3_file_inventory)
```

<BigValue 
  data={latest_day}
  value=size_mb
  title="Size (MB)"
/>

<BigValue 
  data={latest_day} 
  value=folder_level_1_count
  title="Folder (Level 1) Count"
/>

<BigValue 
  data={latest_day} 
  value=file_count
/>

## Used Disk Space (MB) by Day

```sql by_day
select 
    extracted_date as date_day,
    sum(size_mb) as size_mb
from fact_s3_file_inventory
group by 1
order by 1
```

<LineChart
  data={by_day}
  x=date_day
  y=size_mb
/>

```sql largest_folders
select 
    folder_level_1,
    round(sum(size_mb), 0) as size_mb 
from fact_s3_file_inventory
where extracted_date = (select max(extracted_date) from fact_s3_file_inventory)
group by 1
order by 2 desc
```

## Largest Folders (Level 1)

<BarChart 
    data={largest_folders}
    x=folder_level_1
    y=size_mb 
    swapXY=true
/>

```sql largest_files
select 
    folder_level_1,
    folder_level_2,
    file_name,
    round(size_mb, 1) as size_mb
from fact_s3_file_inventory
where extracted_date = (select max(extracted_date) from fact_s3_file_inventory)
order by size_mb desc
limit 30
```

## Largest Files

<DataTable 
    data={largest_files}>
</DataTable>
