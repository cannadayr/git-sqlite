-- migration query
-- sqlite> insert into charlie ( name, time_added) select name, time_added from baz;

-- We are making a baseless assumption
-- that this pseudo, ad-hoc uuid
-- won't produce a collision
-- so we won't need a primary key
CREATE TABLE entity (
    "id" char(36) default (
        lower(hex(randomblob(4)))
            || '-'
            || lower(hex(randomblob(2)))
            || '-4'
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || substr('89ab',abs(random()) % 4 + 1, 1)
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || lower(hex(randomblob(6)))
    ),
    name text,
    txt text,
    time_added timestamp default current_timestamp,
    primary key(id)
) WITHOUT ROWID;

CREATE TABLE tag2entity (
    "id" char(36) default (
        lower(hex(randomblob(4)))
            || '-'
            || lower(hex(randomblob(2)))
            || '-4'
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || substr('89ab',abs(random()) % 4 + 1, 1)
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || lower(hex(randomblob(6)))
    ),
    entity_id char(36), -- id
    tag_id char(36), -- id
    time_added timestamp default current_timestamp,
    primary key(id)
) WITHOUT ROWID;
CREATE INDEX tag2entity__entity_id ON tag2entity(entity_id);
CREATE INDEX tag2entity__tag_id ON tag2entity(tag_id);

CREATE TABLE tag (
    "id" char(36) default (
        lower(hex(randomblob(4)))
            || '-'
            || lower(hex(randomblob(2)))
            || '-4'
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || substr('89ab',abs(random()) % 4 + 1, 1)
            || substr(lower(hex(randomblob(2))),2)
            || '-'
            || lower(hex(randomblob(6)))
    ),
    name text,
    txt text,
    time_added timestamp default current_timestamp,
    primary key(id)
) WITHOUT ROWID;

CREATE VIEW entity_tags AS

SELECT * FROM entity e, tag2entity t2e, tag t
WHERE t2e.entity_id = e.id
AND t2e.tag_id = t.id;

/*

some useful tag queries:

get all the entities that do have (some) tag

select *
from entity e,
    tag2entity t2e
where
    t2e.entity_id = e.id
    and <where_clause about entities or tags>;



get all the entities that DON'T have any tags:

select * from entity e
where not exists (
    select * from tag2entity t2e
    where t2e.entity_id = e.id
)


adding a tags to an entity:

insert into tag2entity (tag_id, entity_id)
values ( (select id from tag where name='<name of tag>'),
         (select id from entity where name='<name of entity>') )


improving our "UUIDs":

select replace(julianday(),".","");
select substr('0000000000000000' || replace(julianday(),".",""), -16, 16);

 select substr(replace(julianday(),".","") || '0000000000000000', 1, 16);


select lower(printf('%08X', strftime("%s") || substr(strftime("%f"), 4, 6)));

select lower(hex(randomblob(4)))
    || '-'
    || lower(hex(randomblob(2)))
    || '-4'
    || substr(lower(hex(randomblob(2))),2)
    || '-'
    || substr('89ab',abs(random()) % 4 + 1, 1)
    || substr(lower(hex(randomblob(2))),2)
    || '-'
    || lower(hex(randomblob(6)));

name                                length(hex)     description
time_low                            8               integer giving the low 32 bits of the time
time_mid                            4               integer giving the middle 16 bits of the time
time_hi_and_version                 4               4-bit "version" in the most significant bits, followed by the high 12 bits of the time
clock_seq_hi_and_res clock_seq_low  4               1-3 bit "variant" in the most significant bits, followed by the 13-15 bit clock sequence
node                                12              the 48-bit node id

*/
