---
order: 20
---

# Git Football League

<https://github.com/fork-n-play/fork-n-play.github.io/wiki/GFL>

<https://bbtactics.com/>
```yml
- gfl
  # Schemas
  - "player.schema.json"
  - "team.schema.json"
  - "creature.schema.json"
  # Team folder
  - team
    # Team files
    - "<team-name>.json"

# Users folder
- user
  # Single user folder
  - <username>
    # Single user game folder
    - gfl
      # Single user game filed
      - "player.json"
```
{% include widgets/form.html file='gfl/player' %}
- Schema `gfl/player.schema.json` has `teamname`, `color_1`, `color_2`, `stadium name`, `slogan` textarea.
- `baserace` string select 
- Document `user/<username>/gfl/player.json`

**Player pull**
Create team
- Schema `gfl/team.schema.json` object
  - `name` string `<team-name>` used as filename: `team.json` became `team/<team-name>.json`
  - `win` `lost` `tie` `fan_factor` default 0
  - `creatures` array of 20 creatures taken from `gfl/creature.schema.json` with `baserace` as input
- Document `gfl/team/<team-name>.json`
Create free agents

- upstream: generate players
- upstream: update calendar
- edit: configure team
- upstream: merge pulls, play games

