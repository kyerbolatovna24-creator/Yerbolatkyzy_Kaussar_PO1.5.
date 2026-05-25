drop user if exists db_reader_user;
drop user if exists db_admin_user;

drop role if exists dvdrental_readonly;
drop role if exists dvdrental_admin;

-- =====================================================
-- PART A — DCL
-- =====================================================

-- create roles

create role dvdrental_admin;

create role dvdrental_readonly;

grant usage on schema public to dvdrental_admin;
grant usage on schema public to dvdrental_readonly;

grant select, insert, update, delete
on all tables in schema public
to dvdrental_admin;

grant select
on all tables in schema public
to dvdrental_readonly;

-- =====================================================
-- create users
-- =====================================================

create user db_admin_user
with password 'Admin123!';

create user db_reader_user
with password 'Reader123!';

grant dvdrental_admin to db_admin_user;

grant dvdrental_readonly to db_reader_user;

-- =====================================================
-- revoke update/delete
-- =====================================================

revoke update, delete
on all tables in schema public
from dvdrental_readonly;

-- =====================================================
-- verify admin user
-- =====================================================

set role db_admin_user;

select current_user;

select count(*)
from film;

insert into film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating
)
values (
    'The Matrix Reloaded',
    'Science fiction action movie',
    2006,
    1,
    7,
    4.99,
    120,
    19.99,
    'PG'
);

update film
set rental_rate = 5.99
where title = 'The Matrix Reloaded';

delete from film
where title = 'The Matrix Reloaded';

reset role;

-- =====================================================
-- verify reader user
-- =====================================================

set role db_reader_user;

select current_user;

select count(*)
from film;

-- expected:
-- permission denied for table film

insert into film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating
)
values (
    'Test Movie',
    'Should fail',
    2006,
    1,
    5,
    2.99,
    100,
    15.99,
    'PG'
);

-- ERROR:
-- permission denied for table film

update film
set rental_rate = 9.99
where film_id = 1;

-- ERROR:
-- permission denied for table film

delete from film
where film_id = 1;

-- ERROR:
-- permission denied for table film

reset role;

-- =====================================================
-- \dp output
-- =====================================================

/*
                                   Access privileges
 Schema | Name | Type  | Access privileges
--------+------+-------+------------------------------
 public | film | table | dvdrental_admin=arwd/postgres
        |      |       | dvdrental_readonly=r/postgres
*/

-- =====================================================
-- revoke readonly role from admin
-- =====================================================

revoke dvdrental_readonly from db_admin_user;

-- =====================================================
-- PART B — INSERT
-- =====================================================

insert into film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating
)
values
(
    'Cyber Future',
    'Sci-fi movie about artificial intelligence',
    2006,
    1,
    5,
    4.99,
    110,
    20.99,
    'PG'
),
(
    'Ocean Secrets',
    'Adventure story in the Pacific Ocean',
    2007,
    1,
    6,
    3.99,
    95,
    18.99,
    'PG-13'
),
(
    'Silent Mountain',
    'Drama about survival in the mountains',
    2008,
    1,
    7,
    5.99,
    130,
    24.99,
    'R'
),
(
    'Golden Horizon',
    'Historical movie about ancient kingdoms',
    2009,
    1,
    4,
    2.99,
    100,
    16.99,
    'PG'
),
(
    'Night Detective',
    'Crime thriller with mystery elements',
    2010,
    1,
    5,
    4.50,
    105,
    19.99,
    'PG-13'
);

-- =====================================================
-- PART C — UPDATE
-- =====================================================

-- business event:
-- rental price increased

select *
from film
where title = 'Cyber Future';

-- rows affected: 1

update film
set rental_rate = 6.99
where title = 'Cyber Future';

-- =====================================================

-- business event:
-- replacement cost updated

select *
from film
where rating = 'PG';

-- rows affected: multiple rows

update film
set replacement_cost = replacement_cost + 5
where rating = 'PG';

-- =====================================================
-- UPDATE ... FROM
-- =====================================================

select f.title,
       l.name
from film f
join language l
on f.language_id = l.language_id
where l.name = 'English';

-- rows affected: multiple rows

update film f
set rental_duration = 10
from language l
where f.language_id = l.language_id
and l.name = 'English';

-- =====================================================
-- PART D — DELETE
-- =====================================================

-- business reason:
-- temporary films added for testing
-- are removed from the catalog

begin;

delete from film
where title in (
    'Cyber Future',
    'Ocean Secrets',
    'Silent Mountain',
    'Golden Horizon',
    'Night Detective'
);

select count(*)
from film;

-- count checked after delete

rollback;