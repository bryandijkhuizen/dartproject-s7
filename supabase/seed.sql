-- Create default avatar
INSERT INTO avatar (id, url) VALUES (1, ' https://cdn.discordapp.com/avatars/243756696403443712/495e571c0a7f70e7fdcc96a9664ff4c7?size=1024');

-- Create test users
SET session_replication_role = replica;
INSERT INTO "user" (id, first_name, last_name, avatar_id)
VALUES
  (gen_random_uuid(), 'Michael', 'van Gerwen', 1),
  (gen_random_uuid(), 'Peter', 'Wright', 1),
  (gen_random_uuid(), 'Gerwyn', 'Price', 1),
  (gen_random_uuid(), 'Rob', 'Cross', 1),
  (gen_random_uuid(), 'Gary', 'Anderson', 1),
  (gen_random_uuid(), 'Nathan', 'Aspinall', 1),
  (gen_random_uuid(), 'Dimitri', 'Van den Bergh', 1),
  (gen_random_uuid(), 'James', 'Wade', 1),
  (gen_random_uuid(), 'Dave', 'Chisnall', 1),
  (gen_random_uuid(), 'Michael', 'Smith', 1),
  (gen_random_uuid(), 'José', 'de Sousa', 1),
  (gen_random_uuid(), 'Jonny', 'Clayton', 1),
  (gen_random_uuid(), 'Daryl', 'Gurney', 1),
  (gen_random_uuid(), 'Mensur', 'Suljovic', 1),
  (gen_random_uuid(), 'Devon', 'Petersen', 1),
  (gen_random_uuid(), 'Danny', 'Noppert', 1);
SET session_replication_role = DEFAULT;
