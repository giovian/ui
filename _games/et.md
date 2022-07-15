---
order: 40
---

# Enemy Territory

Levels from XP: 20, 50, 90 and 140

<https://www.wolffiles.de/etmanual/en/Manual/Default.htm>
``` yml
# Game folder
- et
  # Schemas
  - "player.schema.json"
  - "fireteam.schema.json"
  - "spawn.schema.json"
  - "soldier.schema.json"
  # Fireteam folder
  - fireteam
      # Fireteam files
      - "<fireteam-name>.json"
  # Hexes
  - hex
    # Hexes folder
    - <unix seconds>.json
# Users folder
- user
  # Single user folder
  - <username>
    # Single user game folder
    - et
      # Single user game files
      - "player.json"
```

{% include widgets/form.html file='et/player' %}
- Schema `et/player.schema.json` has `team` (axis or allies), `fireteam_name` and team `class` (x5)
- Document `user/<username>/et/player.json`

**Player pull**
Create soldiers
- Schema `et/fireteam.schema.json` object
  - `name` string <fireteam-name> used as filename: `fireteam.json` became `fireteam/<firetem-name>.json`
  - `soldiers` array of 5 soldiers taken from `et/soldier.schema.json` with input `team` and `class`
- Document `et/fireteam/<fireteam-name>.json`
Create spawn hex
- Schema `et/hex.schema.json` object
  - `number` unix seconds used as filename: `hex.json` became `hex/<unix seconds>.json`
  - `x`, `y` coordinates
  - `terrain` string select
  - `building` string select (empty too)
- Schema `et/spawn.schema.json` object
  - `hex` number
  - `team` spawning
  - `spawn_time` next spawn
  - `spawn_interval` between spawns
  - `building` string select
Create surrounding hexes

# Rank table

- Private First Class/Oberschütze: 1 level advancement in any skill
- Corporal/Gefreiter: 2 levels advancements of the same skill
- Sergeant/Feldwebel: 3 levels advancements of the same skill
- Lieutenant/Leutnant: 4 levels advancements of the same skill (max)
- Captain/Hauptmann: 2 fully developed skills (level 4)
- Major: 3 fully developed skills
- Colonel/Oberst: 4 fully developed skills (requires class change)
- Brigadier General/ Generalmajor: 5 fully developed skills
- Lieutenant General/ Generalleutnant: 6 Fully developed skills
- General: 7 fully developed skills (all classes)

**To do**
- edit: missions
- upstream: update map, resolve battles