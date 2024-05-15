-- add current_score (int8) and current_score2 (int8) to turn table
ALTER TABLE turn ADD COLUMN current_score INT8;
ALTER TABLE turn ADD COLUMN current_score2 INT8;

-- alter column winner_id (uuid) in set table to be default null and nullable
ALTER TABLE set ALTER COLUMN winner_id SET DEFAULT NULL;
ALTER TABLE set ALTER COLUMN winner_id DROP NOT NULL;

-- alter column winner_id (uuid) in leg table to be default null and nullable
ALTER TABLE leg ALTER COLUMN winner_id SET DEFAULT NULL;
ALTER TABLE leg ALTER COLUMN winner_id DROP NOT NULL;
