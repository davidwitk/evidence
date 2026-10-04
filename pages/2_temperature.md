---
title: 2. Temperature 
---

The data in the following charts is extracted every 20 minutes from [OpenWeatherMap](https://openweathermap.org/). 

```sql temperature_date_bounds
select measured_at_cet as measured_date
from fct_weather
```

```sql temperature_yesterday
select
    location_name,
    date_trunc('day', measured_at) as measured_date,
    round(avg(temperature), 2) as temperature_avg
from fct_weather
where date_trunc('day', measured_at) = current_date - INTERVAL '1 DAY'
group by 1, 2
order by 1
```

Yesterday's (<Value data={temperature_yesterday} column=measured_date/>) average temperatures (in °C):

<DataTable data={temperature_yesterday}>
    <Column id=location_name align=center title='Location'/>
    <Column id=temperature_avg align=center contentType=colorscale scaleColor=red/>
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
    measured_at_cet::date between '${inputs.hourly_temperature_dates.start}' and '${inputs.hourly_temperature_dates.end}'
    and location_name like '${inputs.location.value}'
group by 1, 2
order by 1 desc
```

<DateRange
    name=hourly_temperature_dates
    data={temperature_date_bounds}
    dates=measured_date
    title="Measurement date"
    defaultValue="Last 7 Days"
/>

<LineChart
  data={temperature_hourly_by_location}
  x=date_hour
  y=temperature_avg
  series=location_name
    title = "Average Hourly Temperature by Location"
/>

```sql temperature_daily_by_location
select 
    date_trunc('day', measured_at_cet) as date_day, 
    location_name,
    avg(temperature) as temperature_avg, 
    avg(temperature_feels_like) as temperature_feels_like_avg
from fct_weather
where 
    measured_at_cet::date between '${inputs.daily_temperature_dates.start}' and '${inputs.daily_temperature_dates.end}'
    and location_name like '${inputs.location.value}'
group by 1, 2
order by 1 desc
```

<DateRange
    name=daily_temperature_dates
    data={temperature_date_bounds}
    dates=measured_date
    title="Measurement date"
    defaultValue="Last 6 Months"
/>

<LineChart
  data={temperature_daily_by_location}
  x=date_day
  y=temperature_avg
  series=location_name
    title = "Average Daily Temperature by Location"
/>
