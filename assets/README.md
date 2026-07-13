# BioQuest Assets

Drop real art and audio here later. The app renders labeled placeholder shapes
when an image file is missing and silently skips music if the track is missing,
so the game runs fine before any assets are added.

## Low-end device guidance (important)
- **Images**: keep source PNG/JPG <= 1280x720 (the game's logical canvas size).
  Bigger images waste RAM on cheap phones. The app decodes at display size.
- **Audio**: use a small looping track, mono, ~96-128 kbps. Keep it short; it loops.

## Expected filenames

### assets/audio/
- `background_music.mp3`  <-- REPLACE-ME: looping background music (cover + general)

### assets/images/avatars/
- `avatar_1.png` ... `avatar_6.png`  (selectable player avatars; feminine pants/shirt/shoes options, no skirts)
- `guide.png`                         (the talking guide/mentor avatar)

### assets/images/backgrounds/
- `cover.png`        (title/cover screen)
- `basecamp.png`     (mission orientation)
- `map.png`          (expedition map)

### assets/images/stations/
- `station1.png` ... `station5.png`  (per-station themed backgrounds)

### assets/images/phytochem/
- `reaction_1.png` ... `reaction_5.png`  (Station 4 phytochemical reaction
  illustrations, one per test row: Alkaloids, Flavonoids, Tannins, Saponins,
  Glycosides. CRUCIAL for the rating activity - the placeholder shows a flask
  icon until the real lab photos are added.)

### assets/images/ui/
- `badge_research_beginner.png`, `badge_field_pathfinder.png`,
  `badge_data_collection.png`, `badge_bioactive.png`, `badge_data_decoding.png`
- `certificate_frame.png`
