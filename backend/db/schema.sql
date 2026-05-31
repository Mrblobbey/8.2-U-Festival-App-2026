CREATE DATABASE IF NOT EXISTS ufestival CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ufestival;

CREATE TABLE IF NOT EXISTS stages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description_nl TEXT,
  description_en TEXT,
  color VARCHAR(7) DEFAULT '#F03228',
  lat DECIMAL(10, 8),
  lng DECIMAL(11, 8)
);

CREATE TABLE IF NOT EXISTS acts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  genre VARCHAR(100),
  description_en TEXT,
  image_url VARCHAR(255),
  youtube_url VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS schedule (
  id INT AUTO_INCREMENT PRIMARY KEY,
  act_id INT NOT NULL,
  stage_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  FOREIGN KEY (act_id) REFERENCES acts(id),
  FOREIGN KEY (stage_id) REFERENCES stages(id)
);

CREATE TABLE IF NOT EXISTS news (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title_nl VARCHAR(255) NOT NULL,
  title_en VARCHAR(255) NOT NULL,
  content_nl TEXT,
  content_en TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Stages
INSERT INTO stages (name, description_nl, description_en, color, lat, lng) VALUES
('Ponton', 'Main stage – grootste acts van het festival', 'Main stage – biggest acts of the festival', '#F03228', 52.07340, 5.08540),
('The Lake', 'Opkomend talent aan het water', 'Upcoming talent by the water', '#247BA0', 52.07280, 5.08620),
('The Club', 'Theater en stand-up comedy in het clubhuis', 'Theater and stand-up comedy in the clubhouse', '#E3B505', 52.07390, 5.08450),
('Hangar', 'Non-stop house, techno & dance', 'Non-stop house, techno & dance', '#000000', 52.07310, 5.08700);

-- Acts
INSERT INTO acts (name, genre, description_en, youtube_url) VALUES
('Armin van Buuren', 'Trance', 'Five-time "World\'s No. 1 DJ" and trance icon, Armin delivers euphoric, high-energy sets that have headlined festivals from Tomorrowland to Ultra. His uplifting melodies and impeccable mixing keep crowds dancing for hours.', 'https://www.youtube.com/watch?v=TxvpctgU_s8'),
('Martin Garrix', 'EDM', 'Broke through as a teenager with "Animals," Martin Garrix has become one of the biggest names in EDM. His anthemic big-room tracks and stadium-sized drops make him a festival favorite across Europe.', 'https://www.youtube.com/watch?v=Zv1QV6lrc_Y'),
('Kensington', 'Indie Rock', 'Rotterdam-born indie rock quintet known for soaring choruses and driving guitar riffs. Hits like "Streets" and "Riddles" showcase their knack for arena-ready hooks and emotionally charged lyricism.', 'https://www.youtube.com/watch?v=IH77eOyV95o'),
('Within Temptation', 'Symphonic Metal', 'Symphonic metal pioneers fronted by Sharon den Adel. Their cinematic soundscapes and operatic vocals (think "Ice Queen," "Mother Earth") translate into dramatic, visually stunning festival performances.', 'https://www.youtube.com/watch?v=iQVei5C2N4E'),
('De Staat', 'Experimental Rock', 'Experimental rock outfit from Nijmegen, blending funky grooves with angular guitar work and theatrical stagecraft. Tracks like "Witch Doctor" and "Down Town" highlight their genre-bending approach and infectious energy.', 'https://www.youtube.com/watch?v=0ttGgIQpAUc'),
('Chef''Special', 'Funk-Pop', 'A four-piece from Haarlem mixing funk, pop, rock and hip-hop. Their upbeat, genre-fluid sound on songs like "Amigo" and "In Your Arms" makes for joyous, dance-floor-friendly live shows.', 'https://www.youtube.com/watch?v=l3jRIr44lss'),
('Navarone', 'Rock', 'Utrecht''s hard-hitting rock four-piece, delivering riff-driven anthems and dynamic vocals. With a live reputation for raw intensity, they''re tailor-made for late-night main stages.', 'https://www.youtube.com/watch?v=EvLpaCSnc4k'),
('Dotan', 'Folk-Pop', 'Folk-pop singer-songwriter whose intimate voice and acoustic arrangements (notably on "Home") have earned him platinum sales and sell-out shows. His heartfelt storytelling connects deeply on festival acoustic stages.', 'https://www.youtube.com/watch?v=FZEuqzW16Nw'),
('Eefje de Visser', 'Indie-Pop', 'Indie-pop artist crafting atmospheric, electronic-tinged songs. Her hypnotic vocals and lush production (as heard on "Ongeveer") create a dreamlike vibe perfect for twilight festival slots.', 'https://www.youtube.com/watch?v=6IlLJNmLDMg'),
('Froukje', 'Pop', 'Breakthrough pop singer Froukje Veenstra combines candid lyrics with catchy, synth-driven hooks. Since her 2021 debut, she''s become a voice of her generation — ideal for mid-day festival stages.', 'https://www.youtube.com/watch?v=g4PlReX9e-E'),
('Spinvis', 'Lo-fi / Indie', 'Erik de Jong performs under the moniker Spinvis, crafting poetic, collage-like songs that blend spoken-word snippets, lo-fi electronics and wistful pop. His live shows turn everyday observations into shared, dreamlike experiences.', 'https://www.youtube.com/watch?v=F3ZTrGWSLf4');

-- Schedule (placeholder – pas tijden aan op basis van het echte blokkenschema PDF)
-- Ponton (id=1)
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
(4, 1, '2026-09-05 13:00:00', '2026-09-05 14:30:00'), -- Within Temptation
(3, 1, '2026-09-05 15:30:00', '2026-09-05 17:00:00'), -- Kensington
(2, 1, '2026-09-05 19:00:00', '2026-09-05 20:30:00'), -- Martin Garrix
(1, 1, '2026-09-05 21:30:00', '2026-09-05 23:00:00'); -- Armin van Buuren

-- The Lake (id=2)
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
(8, 2, '2026-09-05 13:30:00', '2026-09-05 15:00:00'), -- Dotan
(7, 2, '2026-09-05 16:00:00', '2026-09-05 17:30:00'), -- Navarone
(5, 2, '2026-09-05 18:30:00', '2026-09-05 20:00:00'); -- De Staat

-- The Club (id=3)
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
(10, 3, '2026-09-05 14:00:00', '2026-09-05 15:00:00'), -- Froukje
(9,  3, '2026-09-05 16:30:00', '2026-09-05 17:30:00'), -- Eefje de Visser
(6,  3, '2026-09-05 20:30:00', '2026-09-05 22:00:00'); -- Chef'Special

-- Hangar (id=4)
INSERT INTO schedule (act_id, stage_id, start_time, end_time) VALUES
(11, 4, '2026-09-05 18:00:00', '2026-09-05 19:30:00'); -- Spinvis

-- Sample news items
INSERT INTO news (title_nl, title_en, content_nl, content_en) VALUES
('Welkom op het ❤️U Festival 2026!', 'Welcome to ❤️U Festival 2026!', 'Het festival is officieel geopend. Geniet van de muziek, de sfeer en het gezelschap!', 'The festival is officially open. Enjoy the music, the atmosphere and the company!'),
('Gratis shuttlebus vanaf Utrecht Centraal', 'Free shuttle bus from Utrecht Central', 'De gratis shuttlebus rijdt tussen 12:00 en 19:00 uur richting het festivalterrein. Instappunt: Mineurslaan.', 'The free shuttle bus runs between 12:00 and 19:00 towards the festival grounds. Boarding point: Mineurslaan.'),
('Lockers beschikbaar bij de ingang', 'Lockers available at the entrance', 'Er zijn kluisjes beschikbaar bij de hoofdingang. Betalen gaat uitsluitend via PIN.', 'Lockers are available at the main entrance. Payment by PIN only.');
