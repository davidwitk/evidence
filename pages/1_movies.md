---
title: 1.  Movies 
---

<Tabs>
    <Tab label=" IMDb Top 250">

The data is based on a daily extract of the [IMDb Top 250](https://www.imdb.com/chart/top/). 

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
  title="New Movies - Rank over Time"
  chartAreaHeight=250
/>


```sql latest_day
select 
    *,
    rank * -1 as rank_negative
from fct_imdb_movies_daily
where is_latest_day
order by rating_count desc

```

<ScatterPlot
  data={latest_day}
  x=year
  y=rating_count
  series=title
  title="Rating Count by Year"
  xMin=1920
  xMax=2030
  chartAreaHeight=250
/>

<ScatterPlot
  data={latest_day}
  x=year
  y=rank_negative
  yAxisTitle=Rank
  series=title
  title="Rank by Year"
  xMin=1920
  xMax=2030
  chartAreaHeight=250
/>


```sql imdb_movies_new
select 
    title,
    min(extracted_at) as entry_date,
    year,
    link
from fct_imdb_movies_daily
where first_extraction_day > first_extraction_day_overall
group by 1, 3, 4
order by 2 desc
```

```sql movies_by_rating_count
select *
from fct_imdb_movies_daily
where is_latest_day
order by rating_count desc
```

<BarChart 
    data={movies_by_rating_count}
    x=title 
    y=rating_count
    title="Movies by Rating Count"
/>

New movies that entered the list: 

<DataTable 
    data={imdb_movies_new}
    rows=5
></DataTable>

```sql imdb_movies_left
select 
    title,
    extracted_at :: date as leave_date,
    year,
    link
from fct_imdb_movies_daily
where 
    title_first not in (select distinct title_first from fct_imdb_movies_daily where extracted_at :: date = (select max(extracted_at :: date) from fct_imdb_movies_daily))
    and is_latest_day
order by 2 desc 
```

Movies that left the list: 

<DataTable 
    data={imdb_movies_left}
    rows=5
></DataTable>

Movies with large movements:

```sql imdb_movies_movements
with by_title as (

    select 
        title_first,
        --link,
        --first_extraction_day,
        min(extracted_at :: date) as first_day_in_list,
        max(extracted_at :: date) as last_day_in_list,
        sum(case when extracted_at :: date = first_extraction_day :: date then rank else null end) as rank_first_day,
        sum(case when extracted_at :: date = (select distinct max(extracted_at :: date) from fct_imdb_movies_daily) then rank else null end) as rank_today,
        sum(case when extracted_at :: date = first_extraction_day :: date then rank else null end) - sum(case when extracted_at :: date = (select distinct max(extracted_at :: date) from fct_imdb_movies_daily) then rank else null end) as diff
    from fct_imdb_movies_daily
    where extracted_at :: date = first_extraction_day :: date
      or extracted_at :: date = (select distinct max(extracted_at :: date ) from fct_imdb_movies_daily)
    group by 1

)

select 
    *
from by_title
where abs(diff) > 10
order by diff desc nulls last
```

<DataTable 
    data={imdb_movies_movements}>
</DataTable>


    </Tab>
    <Tab label="Mubi Top 1000">

The data is based on a weekly extract of the [Mubi Top 1000](https://mubi.com/en/lists/the-top-1000/). 

```sql mubi_latest_day
select 
    movie_title as title, 
    movie_year as year, 
    movie_rank as rank, 
    movie_rank * -1 as rank_mirrored,
    movie_popularity as popularity
from fct_mubi_movies_weekly
where date_week = (select max(date_week) from fct_mubi_movies_weekly)
order by movie_rank asc
```

<ScatterPlot
  data={mubi_latest_day}
  x=year
  y=popularity
  series=title
  title="Popularity by Year"
  yMin=0
  xMin=1900
  xMax=2030
  chartAreaHeight=250
/>

<ScatterPlot
  data={mubi_latest_day}
  x=year
  y=rank_mirrored
  series=title
  title="Rank by Year"
  yAxisTitle="Rank"
  xMin=1900
  xMax=2030
  yMin=-1000
  yMax=-1
  chartAreaHeight=250
/>

<ScatterPlot
  data={mubi_latest_day}
  x=rank_mirrored
  y=popularity
  series=title
  title="Rank by Popularity"
  xAxisTitle="Rank"
  xMin=-1000
  xMax=-1
  chartAreaHeight=250
/>

```sql mubi_movies_new
select 
    movie_title,
    date_week,
    date_add(date_trunc('week', first_extraction_day), - interval 1 day) as entered_list_at,
    movie_rank,
    movie_popularity,
    movie_year,
    movie_url
from fct_mubi_movies_weekly
where 
    entered_list_at = date_week :: date
    and entered_list_at > first_extraction_day_overall
order by 2 desc, 3 asc
```

Movies that entered the list: 

<DataTable 
    data={mubi_movies_new}>
</DataTable>


```sql mubi_movies_movements
with by_title as (

    select 
        movie_title,
        --movie_url,
        min(date_week :: date) as first_day_in_list,
        max(date_week :: date) as last_day_in_list,
        sum(case when date_week = (select distinct min(date_week) from fct_mubi_movies_weekly) then movie_rank else null end) as rank_first_day,
        sum(case when date_week = (select distinct max(date_week) from fct_mubi_movies_weekly) then movie_rank else null end) as rank_today,
        sum(case when date_week = (select distinct min(date_week) from fct_mubi_movies_weekly) then movie_rank else null end) - sum(case when date_week = (select distinct max(date_week) from fct_mubi_movies_weekly) then movie_rank else null end) as diff
    from fct_mubi_movies_weekly
    where date_week = (select distinct min(date_week) from fct_mubi_movies_weekly)
      or date_week = (select distinct max(date_week) from fct_mubi_movies_weekly)
    group by 1

)

select 
    *
from by_title
where abs(diff) > 50
order by diff desc nulls last
```

<DataTable 
    data={mubi_movies_movements}>
</DataTable>

    </Tab>
</Tabs>

