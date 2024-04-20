---
title: 2. Temperature 
---

The data in the following charts is extracted every 20 minutes from [OpenWeatherMap](https://openweathermap.org/). 

```sql temperature_latest_measurements
with

base as (

select
    measured_at_cet,
    location_name,
    max(measured_at) over (partition by location_name) = measured_at as is_latest_measurement,
    temperature 
from fct_weather

)

select *
from base
where is_latest_measurement
order by location_name
```

Current temperatures (in °C): 

<DataTable data={temperature_latest_measurements}>
    <Column id=location_name align=center title='Location'/>
    <Column id=measured_at_cet align=center fmt='dd/mm/yyyy H:MM' title='Time'/>
    <Column id=temperature contentType=colorscale scaleColor=red/>
</DataTable>

```sql locations
select 
    location_name
from fct_weather
group by 1
```

<Dropdown
    name=location
    data={locations}
    value=location_name
>
    <DropdownOption value="%" valueLabel="All"/>
</Dropdown>

```sql temperature_hourly_by_location
select 
    date_trunc('hour', measured_at_cet) as date_hour, 
    location_name,
    avg(temperature) as temperature_avg, 
    avg(temperature_feels_like) as temperature_feels_like_avg
from fct_weather
where 
    _sdc_extracted_at >= current_date - interval 7 day
    and location_name like '${inputs.location.value}'
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
    date_trunc('day', measured_at_cet) as date_day, 
    location_name,
    avg(temperature) as temperature_avg, 
    avg(temperature_feels_like) as temperature_feels_like_avg
from fct_weather
where 
    _sdc_extracted_at >= current_date - interval 180 day
    and location_name like '${inputs.location.value}'
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
