-- filter parcels to just meyerson address
-- spatial join w block group and pull geoid

with

meyerson_parcel as (
    select * from phl.pwd_parcels
    where address = '220-30 S 34TH ST'
)

select census.blockgroups_2020.geoid as geo_id from census.blockgroups_2020
join meyerson_parcel
    on st_intersects(census.blockgroups_2020.geog, meyerson_parcel.geog);
