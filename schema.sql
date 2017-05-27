CREATE TABLE bar (
    id integer primary key,
    name text,
    time_added timestamp default current_timestamp
);

-- We are making a baseless assumption
-- that this pseudo, ad-hoc uuid
-- won't produce a collision
-- so we won't need a primary key
CREATE TABLE baz (
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
    time_added timestamp default current_timestamp
);
