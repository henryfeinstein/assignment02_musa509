with

route_shapes as (
    select
        shape_id,
        st_makeline(array_agg(st_setsrid(st_makepoint(shape_pt_lon, shape_pt_lat), 4326) order by shape_pt_sequence)) as geog
    from septa.bus_shapes
    group by shape_id
),

bus_trip_shapes as (
    select
        shapes.geog,
        st_length(shapes.geog::geography) as shape_length,
        trips.trip_headsign,
        trips.route_id
    from route_shapes as shapes
    inner join septa.bus_trips as trips using (shape_id)
)

select distinct
    routes.route_short_name,
    shapes.trip_headsign,
    shapes.geog as shape_geog,
    shapes.shape_length
from bus_trip_shapes as shapes
inner join septa.bus_routes as routes using (route_id)
order by shapes.shape_length desc
limit 2;
