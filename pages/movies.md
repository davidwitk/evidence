---
title: Movies 
---

The data is based on a daily extract of the [IMDb Top 250](https://www.imdb.com/chart/top/). 

```sql imdb_movies_new
select 
	title, 
	min(extracted_at) as entry_date
from fct_imdb_movies_daily
where first_extraction_day > first_extraction_day_overall
group by 1
order by 2 desc
```

New movies that entered the list: 

<DataTable data={imdb_movies_new}>
</DataTable>

```sql imdb_movies_new_daily
with 

base as (

    select 
        *,
        min(rank) over (partition by title) as rank_min
    from fct_imdb_movies_daily
    where first_extraction_day > first_extraction_day_overall

)

select 
    extracted_at :: date as date_day,
    title,
    max(rank) * -1 as rank
from base
where rank_min <= 240
group by 1, 2
order by 1, 2
```

<LineChart
  data={imdb_movies_new_daily}
  x=date_day
  y=rank
  series=title
  title = "New Movies - Rank over Time"
/>
