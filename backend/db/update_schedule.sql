USE ufestival;

-- Act-foto's koppelen
UPDATE acts SET image_url = '/images/acts/kensington.png'       WHERE name = 'Kensington';
UPDATE acts SET image_url = '/images/acts/within-temptation.png' WHERE name = 'Within Temptation';
UPDATE acts SET image_url = '/images/acts/de-staat.png'          WHERE name = 'De Staat';
UPDATE acts SET image_url = '/images/acts/spinvis.png'           WHERE name = 'Spinvis';
UPDATE acts SET image_url = '/images/acts/dotan.png'             WHERE name = 'Dotan';
UPDATE acts SET image_url = '/images/acts/navarone.png'          WHERE name = 'Navarone';
UPDATE acts SET image_url = '/images/acts/chefspecial.png'       WHERE name = 'Chef''Special';

-- Bestaand schema verwijderen
DELETE FROM schedule;

-- ZATERDAG 5 september 2026 — Ponton (hoofdpodium)
-- Tijden gebaseerd op blokkenschema.png
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
((SELECT id FROM acts WHERE name = 'Armin van Buuren'), 1, '2026-09-05 10:30:00', '2026-09-05 12:15:00'),
((SELECT id FROM acts WHERE name = 'Kensington'),       1, '2026-09-05 13:30:00', '2026-09-05 15:00:00'),
((SELECT id FROM acts WHERE name = 'De Staat'),         1, '2026-09-05 15:30:00', '2026-09-05 17:00:00'),
((SELECT id FROM acts WHERE name = 'Navarone'),         1, '2026-09-05 17:00:00', '2026-09-05 18:45:00'),
((SELECT id FROM acts WHERE name = 'Dotan'),            1, '2026-09-05 19:15:00', '2026-09-05 20:45:00'),
((SELECT id FROM acts WHERE name = 'Froukje'),          1, '2026-09-05 21:30:00', '2026-09-05 23:30:00');

-- ZONDAG 6 september 2026 — Ponton (hoofdpodium)
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
((SELECT id FROM acts WHERE name = 'Martin Garrix'),    1, '2026-09-06 10:30:00', '2026-09-06 12:30:00'),
((SELECT id FROM acts WHERE name = 'Within Temptation'),1, '2026-09-06 13:30:00', '2026-09-06 15:30:00'),
((SELECT id FROM acts WHERE name = 'Chef''Special'),    1, '2026-09-06 16:00:00', '2026-09-06 18:00:00'),
((SELECT id FROM acts WHERE name = 'Eefje de Visser'),  1, '2026-09-06 19:00:00', '2026-09-06 21:00:00'),
((SELECT id FROM acts WHERE name = 'Spinvis'),          1, '2026-09-06 21:30:00', '2026-09-06 23:30:00');
