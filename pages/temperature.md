# Temperature

The data in the following charts is extracted every 20 minutes from [OpenWeatherMap](https://openweathermap.org/). 

```sql temperature_latest_measurements
with

base as (

select
    measured_at at time zone 'utc' at time zone 'europe/berlin' as measured_at,
    location_name,
    max(measured_at) over (partition by location_name) = measured_at as is_latest_measurement,
    temperature
from analytics.fct_weather

)

select *
from base
where is_latest_measurement
```

{#each temperature_latest_measurements as measurement}

- The current temperature in <Value data={measurement} column=location_name/> is <Value data={measurement} column=temperature/>°C orders at <Value data={measurement} column=measured_at fmt=hms/>.

{/each}


```sql temperature_hourly_by_location
select 
    date_trunc('hour', measured_at at time zone 'utc' at time zone 'europe/berlin') as date_hour, 
    location_name,
    avg(temperature) as temperature_avg, 
    avg(temperature_feels_like) as temperature_feels_like_avg
from analytics.fct_weather
where 
    _sdc_extracted_at >= current_date - interval '7 day'
group by 1, 2
order by 1 desc
```

<LineChart
  data={temperature_hourly_by_location}
  x=date_hour
  y=temperature_avg
  series=location_name
  title = "Average Hourly Temperature by Location last 7 days"
/>

```sql temperature_daily_by_location
select 
    date_trunc('day', measured_at at time zone 'utc' at time zone 'europe/berlin') as date_day, 
    location_name,
    avg(temperature) as temperature_avg, 
    avg(temperature_feels_like) as temperature_feels_like_avg
from analytics.fct_weather
where 
    _sdc_extracted_at >= current_date - interval '180 day'
group by 1, 2
order by 1 desc
```

<LineChart
  data={temperature_daily_by_location}
  x=date_day
  y=temperature_avg
  series=location_name
  title = "Average Daily Temperature by Location last 180 days"
/>