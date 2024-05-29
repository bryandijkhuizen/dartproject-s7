insert into
  role_permission (role_id, permission_id)
values
  --user permissions
  (1, 2),
  (1, 3),
  (1, 4),
  (1, 11),
  (1, 18),
  (1, 19),
  (1, 27),
  (1, 28),
  (1, 29),
  --marker
  (2, 11),
  (2, 12),
  --tournament organiser
  (3, 5),
  (3, 7),
  (3, 9),
  (3, 14),
  (3, 16),
  (3, 27),
  (3, 28),
  --Darts association
  (4, 5),
  (4, 7),
  (4, 9),
  (4, 14),
  (4, 16),
  (4, 20),
  (4, 22),
  --system administrator
  (5, 30),
  (5, 31);
insert into
  club_role_permission (club_role_id, permission_id)
values
  --members manager
  (1, 23),
  --club marketing
  (2, 24),
  (2, 25),
  (2, 26),
  --club tournament organiser
  (3, 6),
  (3, 8),
  (3, 10),
  (3, 15),
  (3, 17),
  --club administrator
  (4, 6),
  (4, 8),
  (4, 10),
  (4, 15),
  (4, 17),
  (4, 21),
  (4, 23),
  (4, 24),
  (4, 25),
  (4, 26),
  (4, 27),
  (4, 28),
  (4, 32),
  -- club marker
  (5, 13);
