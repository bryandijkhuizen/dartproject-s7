ALTER TABLE club ADD COLUMN status VARCHAR(255) DEFAULT 'pending_application' NOT NULL;
ALTER TABLE club ADD COLUMN note TEXT;