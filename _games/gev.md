---
order: 50
---

# Ground Effect Vehicle

<http://www.sjgames.com/ogre/resources/img/Ogre_6th_Battlefields_Rules.pdf>

|Schema|Document
|---|---
|`gev/player.schema.json`   |`user/<username>/gev/player.json`
|`gev/command.schema.json`  |`gev/command/<name>.json`
|`gev/points.schema.json`   |`gev/points.json`
|`gev/units.schema.json`    |`gev/units.json`
|`gev/map.schema.json`      |`gev/map/<unix>.json`

{% include widgets/form.html file='gev/player' %}
- Schema `gev/player.schema.json` has `name` and `slogan`
- `side` string select Ogre/Human
- Document `user/<username>/gev/player.json`

**Player pull**
Create commad
- Schema `gev/command.schema.json` object
  - `name` string used as filename: `command.json` became `command/<name>.json`
  - `vp` number victory points
  - `infranty_points`, `armour_points`, `ogre_points` taken from `gev/points.json` with `side` as input
  - `units` array of units taken from `gev/units.json` with `side` as input until consuming `infranty_points`, `armour_points`, `ogre_points`

Create points
- Schema `gev/points.schema.json` CSV type Array
  - `side` Ogre/Human
  - `infranty_points`, `armour_points`, `ogre_points`
- Document `gev/points.json` CSV table
Create units
- Schema `gfl/units.schema.json` CSV type Array
  - Item properties:
    - `side` Ogre/Human
    - `type` Infranty/Armor/Ogre
    - `unit` HVY/MAR/Mark III
    - `name` 
    - `infranty_points`, `armour_points`, `ogre_points`
    - `attack`, `defense`, `range`, `movement_1`, `movement_2`
    - `secondary_battery`, `missiles`, `anipersonnel`, `main_battery`, `tread_units`
    - (relative position) `x`, `y`
    - `alpha`, `vx`, `vy`
    - `disabled` boolean default to `false`
    - `map` unix seconds used to create the map
- Document `gev/units.json` CSV table
Create map
- Schema `gev/map.schema.json`
  - `number` unix seconds used as filename: `map.json` became `map/<unix seconds>.json`
  - `x`, `y` coordinates of map (empty but connected) taken from all other maps
  - `hexes` array of hexes taken from `gev/hex.schema.json` <https://jsfiddle.net/36bjmtax/1/>

- once: name, color, description
- upstream: generate Ogre Mark III and defending battalion
- edit: program units, command posts
- upstream: update map, resolve battles