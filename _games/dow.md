---
order: 10
---

# Dawn of Worlds

<https://github.com/petrosh/diarissues/issues/19#issuecomment-331936518>

``` yml
# Game folder
- dow
  # Schemas
  - "player.schema.json"
  - "worlds.schema.json"
  - "join.schema.json"
  # Worlds folder
  - worlds
    # Worlds files
    - "<worldname>.json"
# Users folder
- user
  # Single user folder
  - <username>
    # Single user game folder
    - dow
      # Single user game files
      - "player.json"
      - "join.json"
```

**Enter game**
{% include widgets/form.html file='dow/player' %}
- Schema `dow/player.schema.json` has string `god_name`
- Document `user/<username>/dow/player.json`

**Player pull**
If worlds are all running or ended, create world waiting
- Worlds schema: `dow/worlds.schema.json` is object
  - `name` string <world-name> used as filename: `worlds.json` became `worlds/<world-name>.json`
  - `status` string (waiting by default, running, ended)
  - `join` array of usernames, default empty
- Worlds documents: `dow/worlds/<world-name>.json`

**Join form**
- A list generator schema take a source and conditions, offer option to add to document array
- Schema `dow/join.schema.json` is a list generator with conditions: waiting and not still joined
- Document `user/<username>/dow/join.json` is CVS table `"World"\n"Altar"\n"Lost Kingdom"`

**Join pull**
- Check all worlds `dow/worlds/<world-name>.json` in `join.json` have `<username>` in `join` array 

**To do**
- turn: earn points, roll points, spend points
- upstream: merge turn, update world