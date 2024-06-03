

CREATE TYPE "Club application status" AS ENUM ('Pending application', 'Approved', 'Rejected', 'Archived', 'Suspended');
ALTER TABLE club ADD COLUMN application_status "Club application status" DEFAULT 'Pending application' NOT NULL;

ALTER TABLE club ADD COLUMN note TEXT;
