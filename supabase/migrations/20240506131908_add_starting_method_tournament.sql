-- Add starter_method column to tournament
create type starter_method as enum (
  'bulloff',
  'random'
);

ALTER TABLE tournament ADD COLUMN starting_method starter_method NOT NULL