drop table if exists widgets;

create table widgets(
  id serial primary key,
  valid_dates daterange
);
