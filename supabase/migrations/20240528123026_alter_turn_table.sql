 -- change the table "turn"
 -- drop column "double_hits"

    ALTER TABLE turn
    DROP COLUMN double_hits;

    ALTER TABLE turn
    ADD COLUMN double_hit BOOLEAN DEFAULT FALSE;

    ALTER TABLE turn
    ADD COLUMN darts_for_checkout INTEGER DEFAULT 3;

    
