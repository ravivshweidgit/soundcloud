# Scene assets — 30-second ad

One folder per shot in `script-30sec.md`. Files are numbered by strength: `1-` is the first choice.
All are full-resolution copies; the originals stay in `ALEX/` (P-numbers below) and `assets/`.

| Folder | Shot | Real photo of Viki? | Use |
|---|---|---|---|
| `00-viki-character` | refs | yes | character reference for every shot |
| `01-plane-window` | 1 | no | generate cabin + Kilimanjaro, Viki from ref |
| `02-arrival-sign` | 2 | yes (selfie) | real sign, no generated lettering |
| `03-coffee-terrace` | 3 | yes | start frame |
| `04-canoe-lake` | 4 | yes | start frame |
| `05-safari-jeep` | 5 | no | animals as background, Viki from ref |
| `06-safari-wide` | 6 | no | background, add jeep + balloon |
| `07-lake-aerial` | 7 | no | background for the drone move |
| `08-tree-path` | 8 | yes | start frame |
| `09-deck-sunset` | 9 | yes | start frame |
| `10-end-card` | 10 | no | background under contact text |
| `extra-60s` | — | yes | room, dress change, monkeys, fire pit, for the 60 s cut |

---

### 00 — Viki character
**Generated character sheets (Nano Banana Pro, 9:16, use these as Viki in every shot)**
- `vikki-04-shop.png`: travel look, camel trench. Shots 1–2.
- `vikki-02-safari.png`: safari outfit. Shots 2–8.
- `vikki-03-evening.png`: olive satin dress. Shots 9–10.
- `vikki-01-desigual.png`: colourful jeans look. 60 s cut only.

Source photos below are in `raw/`.

Rebuild Viki in OpenArt from the best-quality photos, then dress her. Real photos are low-res, wear sunglasses, or are dark.

**Identity (who she is)**
- `viki-face-01.jpg`, `viki-face-02.jpg`: sharp daylight close-ups, no sunglasses (P1000355/356). Main face reference.
- `viki-pool-hq.jpg`: full body by the pool, sharper copy of `viki-pool.jpeg`, watermark cropped. Body, figure and style.
- `viki-full-body.jpeg`: 4K full body, no sunglasses, busy background. Backup body reference.

**Outfits (what she wears), not for the face**
- `viki-safari-hq.jpg`: day safari outfit, sharper crop of `viki-safari.jpeg`. Shots 1–8.
- `viki-evening-dress-front.jpg`, `viki-evening-dress-back.jpg`: evening dress. Shots 9–10. Dark and small in frame, so use only for the dress.
- `viki-pool.jpeg`, `viki-shop.jpeg`, `viki-safari.jpeg`: sunglasses, low-res. Avoid as face reference.

**Build order**
1. Character from the two face close-ups + full body.
2. Day sheet: character + `viki-safari-hq.jpg`.
3. Evening sheet: character + `viki-evening-dress-front.jpg`.
4. Use the two generated sheets as Viki in every shot.

### 01 — Plane window
- `1` business-class window seat, 787-style oval windows, seat empty (selected). Windows are blown out white: the prompt must put Kilimanjaro in the nearest window.
- `2` Viki day outfit ref, to seat her in it

### 02 — Arrival at the sign
Two parts: A (AI, ~1.8 s) jeep on the road, B (real sign, ~1.2 s) sign with Viki's shoulder in the foreground.
- `A-jeep-road/1` vertical tree-lined dirt road, sun through leaves, red gate posts (first choice). `2` road with Meru. `3`, `4` Meru through the trees.
- `B-sign/1` real sign (P1000045). Its pixels are pasted back over the generated frame so the lettering stays exact. `2` selfie at the lodge, location reference only.
- `character/` travel look for this shot.
- `output/` start frames, clips and the final shot.
- `unused/` safari park road, not the lodge.

### 03 — Coffee on the terrace
- `1` **Viki on the terrace from behind, sun hat, looking out over the lake through the trees** (P1000773). Best start frame.
- `2`, `3` Viki walking across the restaurant deck among the tables (P1000770/769)
- `4` empty table with the lake behind (P1000228): end frame, coffee set down
- `5` glass on the terrace rail over the lake (P1000047)
- `6`–`8` waterfront deck and restaurant

### 04 — Canoe on the lake
- `1` **canoe bow gliding under huge overhanging trees, green water** (P1000784). Exotic lake background; add Viki paddling from the ref.
- `2`, `3` Viki in the canoe, sun hat, Mount Meru ahead (P1000795/797). Best real photo for the solo shot.
- `4`, `5` **hotel team in the boat with Viki**, Meru, purple jacaranda, everyone waving (P1000670/671). Strongest lodge image overall: it shows people and hospitality.
- `6` same boat, closer on Viki (P1000668)
- `7` same boat, wider (P1000665)
- `8` Viki in the canoe under the big trees (P1000789)

### 05 / 06 — Safari
Real animals with no Viki. Use as backgrounds with Viki added from the ref.
- 05: zebras, giraffes, elephants with water and mountain
- 06: dirt road across the plain, baobab, elephant herd, river valley. Add the jeep and balloon in the prompt.

### 07 — Back to the lake (aerial)
- `1` lake at sunset, Meru, boat on the water (P1000615)
- `2` Meru over the forest (P1000055)
- `3`–`5` lake, trees, canoes

### 08 — Tree path to the chalet
- `1` **back shot: Viki walking a narrow forest path, sun hat, trees closing overhead** (P1000777). Exactly the script.
- `2`, `3` back shot: Viki going down the stone steps past the chalet gate (P1000746/747)
- `4`, `5` Viki on the path with the chalet roofs below (P1000744/739)
- `6`, `7` Viki arriving on the chalet deck, lake through the trees (P1000749/755)
- `8` path at dusk, no Viki (P1000688)

### 09 — Sunset on the deck
- `1`, `2` **Viki in the dress from behind, looking at the lake at dusk** (P1000730/732). Best match for the script.
- `3`, `4` from the front, leaning on the railing (P1000714/729)
- `5` walking along the deck (P1000720)
- `6` wine glass on the rail (P1000047): prop reference for the red wine

### 10 — End card
- `1` lodge lit up at night, seen from the lake (P1011064). Strongest closing image.
- `2` Viki silhouette in the canoe at dusk (P1011056)
- `3`, `4` chalet lit at dusk
- `5`, `6` sunset through the trees

### Extra (60 s cut)
**Viki stepping into the room from the sunlit deck, bed in front** (P1000758, best room shot), Viki in the room by the window (P1000759), dress change in the room (P1000708), Viki lounging on the deck (P1000757), room interior, vervet monkey on the deck, restaurant at dusk, lounge, fire pit, pool at night.

---

### Suggestion
The team boat photo (`04/4`) is the best "come stay with us" image in the set. Options:
- open shot 4 with the team boat (1.5 s), then cut to Viki's solo canoe (1.5 s), or
- use it in place of shot 7 (the generated drone shot) as the "back at the lodge" moment.
