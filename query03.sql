select 
    parcels.address as address,
    stops.stop_name as stop_name,
    stops.dist as distance
from phl.pwd_parcels as parcels
cross join lateral (
    select 
        stops.stop_name, 
        stops.geog <-> parcels.geog as dist
    from septa.bus_stops as stops
    order by dist
    limit 1
) as stops;