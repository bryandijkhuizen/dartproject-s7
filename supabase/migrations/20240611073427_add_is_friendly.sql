-- add is_friendly bool to "match" table with default value false
ALTER TABLE "match" ADD COLUMN is_friendly bool DEFAULT false;