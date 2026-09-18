# BioQuest: A Journey Toward Research Discovery

An offline, landscape, mobile learning game (Flutter, Android-first) that guides
learners through five moss-research stations from Basecamp to the Discovery
Summit. Built for low-end Android devices.

## Features in this build (foundation + Station 1)
- Cover screen with background music (placeholder track).
- Offline register / login backed by **SQLite** (salted SHA-256; no
  forgot-password / remember-me by design).
- Avatar selection (pants/shirt/shoes outfits, no skirts).
- Basecamp orientation: talking guide, Short Overview / General Instructions /
  Instructional Objectives, each with an optional **voiceover** (TTS) toggle.
- 10-item **Pretest** (auto-scored, answers never revealed).
- **Expedition Map** with a progress chart and sequential station unlocking.
- **Station 1 (Moss Quest)** fully playable:
  - Discovery Stop (scrollable content + voiceover)
  - Research Mission (tap the correct research design; moss-health meter:
    0-4 dying, 5-7 thin/short, 8-9 tall/thick, 10 produces a capsule)
  - Takeaway (free text, rubric-scored 1-5)
  - Trail Checkpoint (10 MC, auto-scored) -> earns the Research Beginner Badge
    and unlocks Station 2.
- Stations 2-5 and the Summit are scaffolded (locked) and reuse the same widgets.

## Low-end device choices
- Uniform-scaling 1280x720 canvas (`lib/core/game_canvas.dart`) keeps shapes
  aligned on every screen and is cheap (one transform).
- `minSdk` = Flutter's supported floor (API 24, Android 7.0).
- Per-ABI split APKs + R8 code/resource shrinking -> small installs
  (~15-17 MB per device).
- Flat colors, minimal shadows, `RepaintBoundary` around animations, lazy lists,
  capped image decode sizes, single looping audio stream.

## Run it
```
flutter pub get
flutter run            # on a connected Android device/emulator
```

Build release (per-ABI APKs land in `build/app/outputs/flutter-apk/`):
```
flutter build apk --release
```

## Replace placeholder assets later
The game runs with labeled placeholder shapes and no music. Drop real files into
`assets/` using the names documented in [assets/README.md](assets/README.md):
- Background music: `assets/audio/background_music.mp3`
- Avatars, backgrounds, station art, phytochem illustrations, badges: see the
  assets README for exact filenames. Keep images <= 1280x720.

## Project structure
```
lib/
  app/        theme + go_router routes
  core/       game canvas + reusable widgets
  services/   db, auth, progress, settings, tts, audio
  models/     data models
  data/       station + pretest content
  features/   screens (cover, auth, avatar, basecamp, pretest, map, station1, summit)
```

## Content source
All learning content, questions, and answer keys are transcribed from the design
document in `plan/`.
