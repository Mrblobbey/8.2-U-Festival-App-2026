USE ufestival;

ALTER TABLE acts ADD COLUMN description_nl TEXT;

UPDATE acts SET description_nl = 'Vijfvoudig ''Beste DJ ter Wereld'' en trance-legende. Armin brengt euforische, energieke sets met opzwepende melodieën en onberispelijke mixing die het publiek urenlang aan het dansen houden.' WHERE name = 'Armin van Buuren';
UPDATE acts SET description_nl = 'Als tiener doorgebroken met ''Animals'', is Martin Garrix uitgegroeid tot een van de grootste namen in de EDM-wereld. Zijn monumentale anthems en stadiongrote drops maken hem een absolute festivalfavoriet door heel Europa.' WHERE name = 'Martin Garrix';
UPDATE acts SET description_nl = 'Rotterdams indie-rockkwintet bekend om de meeslepende refreinen en drijvende gitaarriffs. Hits als ''Streets'' en ''Riddles'' laten hun talent voor arenaklare hooks en emotioneel geladen teksten zien.' WHERE name = 'Kensington';
UPDATE acts SET description_nl = 'Symfonische metal-pioniers met frontvrouw Sharon den Adel. Hun cinematische soundscapes en operatische vocalen zijn een indrukwekkende festivalervaring die je niet snel vergeet.' WHERE name = 'Within Temptation';
UPDATE acts SET description_nl = 'Experimentele rockband uit Nijmegen die funky grooves mengt met hoekige gitaarwerken en theatrale uitvoering. Nummers als ''Witch Doctor'' en ''Down Town'' zijn hiervoor het bewijs.' WHERE name = 'De Staat';
UPDATE acts SET description_nl = 'Viertal uit Haarlem dat funk, pop, rock en hiphop mixt. Hun vrolijke, genre-overschrijdende geluid op nummers als ''Amigo'' en ''In Your Arms'' maakt hun liveshows tot een groot feest.' WHERE name = 'Chef''Special';
UPDATE acts SET description_nl = 'Utrechts hardrockende viertal met riff-gedreven nummers en dynamische vocalen. Met een live-reputatie voor rauwe intensiteit zijn ze perfect op grote festivalpodia laat op de avond.' WHERE name = 'Navarone';
UPDATE acts SET description_nl = 'Singer-songwriter wiens intieme stem en akoestische arrangementen op nummers als ''Home'' hem platina-verkopen en uitverkochte shows hebben opgeleverd. Zijn oprechte verhalen raken diep.' WHERE name = 'Dotan';
UPDATE acts SET description_nl = 'Indie-popartieste met atmosferische, elektronisch getinte nummers. Haar hypnotiserende stem en weelderige productie op ''Ongeveer'' creëren een dromerige sfeer die perfect past bij schemersessies op festivals.' WHERE name = 'Eefje de Visser';
UPDATE acts SET description_nl = 'Doorbraakster Froukje Veenstra combineert openhartige teksten met catchy, synth-gedreven hooks. Sinds haar debuut in 2021 is ze uitgegroeid tot een stem van haar generatie.' WHERE name = 'Froukje';
UPDATE acts SET description_nl = 'Erik de Jong treedt op als Spinvis en maakt poëtische, collageachtige nummers die gesproken woord, lo-fi elektronica en weemoedige pop mengen. Zijn liveshows veranderen alledaagse observaties in gedeelde, dromerige ervaringen.' WHERE name = 'Spinvis';
