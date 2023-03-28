with 

henry_houses as (
    select
        owner1,
        geog
    from phl.pwd_parcels
    where owner1 like '% HENRY %'
)

select
    stop_id,
    stop_name,
    concat('Closest Henry House: ', cast(floor(houses.dist) as varchar), ' meters away, owned by ', houses.owner1) as stop_desc,
    stop_lon,
    stop_lat
from septa.rail_stops as stops
cross join lateral (
    select
        houses.owner1,
        houses.geog <-> stops.geog as dist
    from henry_houses as houses
    order by dist
    limit 1
) as houses;