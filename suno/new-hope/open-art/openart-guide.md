# New Hope — OpenArt step-by-step

Track: `New-hope.wav` (3:57 / 237 s) · Concept: `clip-concept.md`
Asset descriptions: `characters-and-worlds.md` · Shot prompts: `openart-paste.md`

Work in order. Do not start section generation until Phase 1 is approved.

## Build the asset library first

OpenArt has **Character** and **World** tools with a saved asset library, which is the mechanism
behind the `@swan-couple` / `@plate-*` tags in the Poor man rose brief. Register the assets first
and every later shot references a tag instead of re-describing the world and drifting.

**One character, ten worlds.** Full paste-ready descriptions are in `characters-and-worlds.md`:
`@woman`, `@door`, `@lane`, `@river`, `@river-midnight`, `@cherry-bloom`, `@glen`, `@glen-bloom`,
`@glen-midnight`, `@drawn-lane`, `@drawn-river`. Two of them — `@river` and `@glen-bloom` — exist
mainly to build the night versions from, and `@river` never reaches the screen.

Geography lives in the asset; **light lives in the shot prompt** (L1–L7 in that file). Bake a time
of day into a location and every shot using it inherits that time, which kills the film's light arc.

**The Create Background dialog has no description field** — only a name and up to three images. So
the world descriptions in `characters-and-worlds.md` are not pasted anywhere during registration;
they exist to generate and to regenerate plates, and the Director brief carries a short key for each
tag instead. Register **one image per background** so each tag stays distinct: do not bundle
`glen`, `glen-bloom` and `glen-midnight` together, because the brief calls them separately.

---

## Before you open OpenArt

1. Aspect **16:9**, prefer **2k / High**. Add 9:16 later only if needed.
2. **Auto Polish OFF** — it rewrites prompts and will quietly turn the drawn world into 3D.
3. Generate **4 variations** for anything that gets reused (character, style locks, plates).
4. **96 BPM 4/4 → 1 bar = 2.5 s.** Clips are 2 bars (5 s) or 4 bars (10 s). Do not eyeball lengths.

## Hard rules for every generation

- **One woman only.** No second person anywhere, including background and reflections.
- **She is never drawn.** No figure of any kind in the animated world.
- **Two mediums never share a frame** except the very last shot.
- **No instruments and no musicians**, either medium.
- No lip sync, no on-screen lyrics, no text, no watermark.
- Live action stays *below* the drawn world in saturation. Real morning is true, not triumphant.

---

## Phase order, and why this order

The drawn world is the only asset with no precedent in the previous two films, so it gets tested
early and cheaply — before any money goes into plates that assume it works.

| Phase | What | Why here |
|---|---|---|
| 1a | Character lock — sheet **and** face | The film opens on an extreme close-up of eyes. A full-body sheet cannot carry that. |
| 1b | Drawn style test — the cherry tree | Settles the style question with an image instead of an argument. No geography needed yet. |
| 1c | Live-action plates | Geography lock: door, lane, river, winter rain, cherry in rain. |
| 1d | Drawn plates, built from approved live plates | The dream is *this* glen redrawn, so the live plate has to exist first. |
| 2 | Three cheap motion tests | The look into lens, the push through the door, petals to sleet. |
| 3 | Section generation | Only now. |
| 4 | Edit | Grade, medium timing, export. |

---

## Approval checks

### Global — reject immediately

- [ ] A second person, hands, face, or human silhouette anywhere
- [ ] Text, logos, watermarks, subtitles
- [ ] Wrong aspect (not 16:9)
- [ ] Instruments or a musician in frame
- [ ] Live action that looks illustrated, or drawing that looks photographic

### 1a — Character sheet · `character-lock.png`

**Pass when:**
- [ ] Late twenties to early thirties, soft gentle face, natural copper-auburn red hair, freckled — a real face, not a cover model, and **not** weathered or harsh
- [ ] Heavy knit and boots read clearly; clothing is plain and worn
- [ ] Three views, same person, same scale, one ground line
- [ ] Empty hands, neutral A-pose, neutral expression
- [ ] Plain white ground, even light

**Reject when:**
- [ ] Glamour lighting, makeup, styled hair
- [ ] Costume drama, shawl-and-cottage cliché, claddagh jewellery
- [ ] Different face between the three views
- [ ] Anything in her hands

### 1a — Face lock · `face-lock.png` (the one that matters most)

This is the film's first image and its last. Verse 1 is **eyes only**.

**Pass when:**
- [ ] Same woman as the sheet, unmistakably
- [ ] Tight enough that the iris has real detail and texture
- [ ] **Strong single catchlight** in the eye — this is where the withheld sun lives
- [ ] Looking **straight into the lens**, level, not up or away
- [ ] Skin real: pores, wind-redness, no retouching
- [ ] Cool pre-dawn light, gold only in the catchlight

**Reject when:**
- [ ] Soft-focus beauty portrait, smoothed skin
- [ ] No catchlight, or catchlights scattered from many sources
- [ ] Eyes averted, or a coy head tilt
- [ ] Tears — the song is not sad, it is waiting
- [ ] Warm overall grade (that belongs to the verse 1 *return*)

### 1b — Drawn style · `drawn-style-A.png` / `drawn-style-B.png`

Generate both, pick one, then never deviate from it.

**Pass when:**
- [ ] Reads as **hand-made**: paper tooth, brush edges, pigment pooling
- [ ] Sun **and** rain at once, and both are believable at once
- [ ] Rain is drawn as line, not photographed as blur
- [ ] Petals are strokes, not particles
- [ ] More beautiful than a photograph could be — that is its job
- [ ] Celtic ornament present but not costume: knotwork logic in branch and root
- [ ] Empty — no figure, no animals

**Reject when:**
- [ ] Anime or manga faces, eyes, or sakura-park framing
- [ ] Ghibli pastiche so close it reads as a copy
- [ ] 3D, CGI, cel-shaded gloss, vector flatness
- [ ] Photoreal with a filter on it
- [ ] Hard black outlines everywhere
- [ ] Ornament pasted on as a border sticker with nothing behind it

**The choice:** A is ornament living quietly inside the painting. B is an illuminated-manuscript
language with gold grounds. B is more original and far easier to make look cheap. Pick on the
evidence, not the description.

### 1c — Live plates

All plates empty — no woman, no birds, no people. She gets composited in by the video stage.

| Plate | File | Must contain |
|---|---|---|
| Door, closed, cold | `plate-door-cold.png` | Stone cottage gable, plain old door shut, deep shade, gap of dark at the foot |
| Door, lit | `plate-door-lit.png` | Same door, same angle, first gold on the stone above it, interior still black |
| Lane | `plate-lane.png` | Long wet stone lane running away, countably long, dying at a gate or wall |
| Winter rain | *(no dedicated still)* | Use `lane.png`. Rain is a **video** instruction and it is filmed on the water — puddles large in frame, rings on the surface. Streaks in open air fail; impact on water works. |
| River, night | `plate-river-night.png` | Dark water, pebble bed, wet mud bank with room for footprints |
| Cherry, real rain | `plate-cherry-rain.png` | One wild cherry in blossom, real rain, cool and wet, deliberately less lovely than the drawn one |

**Pass when:** same geography across all six — same hill line, same stone, same river. Reject any
plate that invents a new valley.

### 2 — Motion tests

**Test 1 — the look.** Her eyes, static frame, ~5 s. Pass: she holds the lens, micro-movement
only, the catchlight lives. Reject: head turns, blink storms, eyes drift, face morphs.

**Test 2 — through the door.** Slow push at the closed door, it gives way, camera enters black.
Pass: the frame reaches near-black cleanly so the medium can change inside it. Reject: interior
that resolves into a room, the door swinging like a horror beat, geometry bending.

**Test 3 — petals to sleet.** Drawn petals falling, hard change mid-fall to real sleet falling.
Pass: the fall is continuous, the medium is not. Reject: cross-dissolve, or either half
contaminating the other.

---

## Where the build actually stands

Phases 1a–1d are complete. In `assets/`: `women.png`, `women-face.png`, `door.png`, `lane.png`,
`river.png`, `drawn-lane.png`, `drawn-river.png`, `cherry-bloom.png`. Motion tests 2 and 3 are proven
as `vid-test-02.mp4` and `vid-test-03.mp4`, and those two clips are the reference language for the
door push and for drawn petals.

**Phase 3 is Director, not shot-by-shot.** Same route as Poor man rose: register the woman as a
Character and the seven plates as Locations, attach the full audio, and paste the lyric-anchored
section brief — **DIRECTOR FULL TRACK** in `openart-paste.md`. The shot list stays as the review
sheet you check the render against, not as a generation queue.

**What to do right now**

Every still is approved and in `assets/`. Phase 1 is closed; what is left is registration and the
Director run.

1. **Register the assets**: Character `@woman` from `women.png`; Locations `@door` `@lane` `@cherry-bloom`
   `@glen` `@glen-bloom` `@glen-midnight` `@river-midnight` `@drawn-lane` `@drawn-river`. **Do not
   register `river.png`** — it is a base plate and the film has no daylight river.
2. **New Director project → Guide me**, attach those plus the full `New-hope.mp3`, paste the brief.

**Blossom is withheld in live action until Bridge 2.** The cherries are bare in every live plate
except `glen-bloom.png`, `glen-midnight.png`, `river-midnight.png` and `cherry-bloom.png`. `lane.png`
and `river.png` are already correct — their trees are bare.

Budget ~11–12k credits for one full 237 s pass at MiniMax H3 Max 768P. Rejects are not free, so the
brief is worth reading once more before you spend it.
