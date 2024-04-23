-- Create default permissions
INSERT INTO permission (name, description, scope) VALUES ('update_user', 'User can update his own profile.', 'global');
INSERT INTO permission (name, description, scope) VALUES ('delete_user', 'User can delete his own profile.', 'global');
INSERT INTO permission (name, description, scope) VALUES ('play_friendly_match', 'User can play a friendly match.', 'global');
INSERT INTO permission (name, description, scope) VALUES ('create_tournament', 'User can create a tournament for all users.', 'global');
INSERT INTO permission (name, description, scope) VALUES ('create_club_tournament', 'User can create a tournament for all users in a club.', 'club');
INSERT INTO permission (name, description, scope) VALUES ('update_tournament', 'User can update a tournament for all users.', 'global');
INSERT INTO permission (name, description, scope) VALUES ('update_club_tournament', 'User can update a tournament for all users in a club.', 'club');

-- Create default role
INSERT INTO role (id, name) VALUES (1, 'Player');

-- Create default avatar
INSERT INTO avatar (id, url) VALUES (1, ' https://cdn.discordapp.com/avatars/243756696403443712/495e571c0a7f70e7fdcc96a9664ff4c7?size=1024');