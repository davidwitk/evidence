select 
    date_trunc('day', inserted_at) as date_day, 
    mount_path,
    avg(size_used_kb / size_kb :: decimal) as size_used_percentage
from analytics.fct_nextcloud_disk_space
where mount_path in ('/', '/mnt/volume_1')
group by 1, 2
