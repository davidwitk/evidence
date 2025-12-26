---
title: 1.  Movies - Letterboxd
---

```sql letterboxd_diary_summary
select 
    count(*) as total_movies_logged,
    sum(case when date_trunc('year', watch_date) = date_trunc('year', current_date) then 1 else 0 end) total_movies_watched_current_year,
    sum(case when date_trunc('year', watch_date) = date_trunc('year', current_date - interval 1 year) then 1 else 0 end) as total_movies_watched_previous_year
from fct_letterboxd_diary
```

<BigValue 
  data={letterboxd_diary_summary} 
  value=total_movies_logged
/>

<BigValue 
  data={letterboxd_diary_summary} 
  value=total_movies_watched_current_year
/>

<BigValue 
  data={letterboxd_diary_summary} 
  value=total_movies_watched_previous_year
/>

```sql letterboxd_diary_by_month_screen_type
select 
    date_trunc('month', watch_date) as date_month,
    screen_type,
    count(*) as movie_count
from fct_letterboxd_diary
group by all 
order by 1, 2
```

<BarChart 
    data={letterboxd_diary_by_month_screen_type}
    x=date_month
    y=movie_count
    series=screen_type
    title="Movies by Watch Month & Screen Type"
    labels=true
/>

```sql letterboxd_diary_decade
select
    ((floor(year / 10) * 10) :: int) :: string as decade, 
    count(*) as movie_count
from fct_letterboxd_diary
group by all 
order by 1
```

<BarChart 
    data={letterboxd_diary_decade}
    x=decade
    y=movie_count
    title="Movies by Decade"
    labels=true
    swapXY=true
/>

```sql letterboxd_diary_by_month_decade
select 
    date_trunc('month', watch_date) as date_month,
    (floor(year / 10) * 10)::int as decade, 
    count(*) as movie_count
from fct_letterboxd_diary
group by all 
order by 1, 2 desc
```

<BarChart 
    data={letterboxd_diary_by_month_decade}
    x=date_month
    y=movie_count
    series=decade
    title="Movies by Watch Month & Decade"
    labels=true
/>


