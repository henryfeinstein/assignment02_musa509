select
    nhoods.name as neighborhood_name,
    count(case when stops.wheelchair_boarding = 1 then 1 else null end) / nhoods.shape_area  as accessibility_metric,
    count(case when stops.wheelchair_boarding = 1 then 1 else null end) as num_bus_stops_accessible,
    count(case when stops.wheelchair_boarding = 2 then 1 else null end) as num_bus_stops_inaccessible
from azavea.neighborhoods as nhoods
join septa.bus_stops as stops
    on st_intersects(nhoods.geog, stops.geog)
group by nhoods.shape_area, neighborhood_name
order by accessibility_metric desc
limit 5;
