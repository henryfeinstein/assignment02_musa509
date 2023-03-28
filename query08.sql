-- filter out all properties within 19104 and have Upenn as name
-- draw envelope around these properties
-- intersect with block groups and count how many are fully contained

with

penn_zipcode as (
    select geog from phl.zipcodes
    where code = '19104'
),

penn_properties as (
    select 
        objectid,
        phl.universities.geog
    from phl.universities
    join penn_zipcode
    on st_coveredby(phl.universities.geog, penn_zipcode.geog)
    where name = 'University of Pennsylvania' 
),

penn_envelope as (
    select
        st_convexhull(st_collect(geog::geometry))::geography as envelope_geog
    from penn_properties
)

select count(*) as count_block_groups from census.blockgroups_2020 
join penn_envelope
on st_coveredby(census.blockgroups_2020.geog, penn_envelope.envelope_geog)

