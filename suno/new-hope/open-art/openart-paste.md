# New Hope — OpenArt paste prompts

Copy only the block under each `---`. Do not paste the headings.

Guide: `openart-guide.md` · Concept: `clip-concept.md` · Lyrics: `../lyrics-suno.md`

Global finish, live action: filmic live-action photography, natural light, organic 35mm film grain, matte, not illustration, not painting, not 3D, no watermark, no text.

Global finish, drawn: hand-drawn 2D gouache and watercolour on paper, painted light, not photographic, not 3D, no watermark, no text.

---

## CHARACTER SHEET — Phase 1a

No reference image. Text only.

TASK
Create one production-ready three-view character turnaround reference sheet for downstream storyboard and video conditioning. This sheet is made by the film's own production, in the film's own medium. STYLE is that medium: the person, skin, hair, cloth, light falloff and finish are rendered exactly the way the film renders things. The plain white ground and neutral even light are shooting conditions inside that medium — a costume-fitting record made by this production — not a different world and not a different medium.

INPUT ROLE
No identity image is attached. Use the identity description below as the sole physical identity source.
[identity - preserve exactly]: Female figure in her late twenties to early thirties, medium height, soft build. Gentle open face, soft features, warm freckled skin with a light natural flush on the cheeks — kind and calm, not weathered or harsh. Bare face with no makeup. Clear soft green or grey-green eyes. Natural red hair, copper to auburn, worn loose or softly pulled back with loose strands at the temples.

SOURCE WARDROBE BOUNDARY
There is no source-image wardrobe authority. Physical identity text is not wardrobe direction. The CREATIVE LOOK below is the only source of truth for clothing, footwear, accessories, grooming, materials, colours, layers and silhouette.

CREATIVE LOOK
A heavy hand-knitted wool jumper in undyed oatmeal cream, thick cable texture, loose and worn soft, sleeves pushed back at the forearm. A long dark charcoal wool skirt to mid-calf, plain, heavy, hanging straight. Thick dark socks. Scuffed brown leather ankle boots, laced, muddy at the welt. No coat, no shawl, no scarf, no hat, no bag, no jewellery, no watch, no patterns, no prints, no logos. Everything plain, worn, and clearly lived in.

HARD CONSTRAINTS
Empty hands. She carries nothing and holds nothing. Neutral expression, mouth closed, no smile.

STYLE
Filmic live-action photography. Naturalistic skin and cloth, soft light falloff, matte finish, muted desaturated palette, organic 35mm film grain. Not illustration, not painting, not 3D render, not stylised.

SHEET LAYOUT
One wide 16:9 image containing exactly three full-body depictions of the same person. Arrange them left to right as front view, strict 90-degree left profile, and back view. Identical scale, equal spacing, one shared ground line. Show the entire head, hands, legs and boots in every depiction. Neutral A-pose with relaxed hands, eye-level, orthographic-like presentation. Keep the three depictions visually separate; do not overlap them or turn them into panels.

BACKGROUND AND LIGHTING
Pure solid white (#FFFFFF) background edge to edge, including the spaces between views. Soft neutral studio lighting, consistent exposure. Only a subtle contact shadow directly beneath each pair of boots.

DO NOT INCLUDE
No second person. No props, held objects, flowers, baskets, instruments or animals. No glamour lighting, makeup, styled hair or retouched skin. No costume-drama shawl, no claddagh jewellery, no green novelty Irish styling. No environment, furniture, floor pattern or designed page layout. No text, labels, arrows, grids, logos or watermark.

---

## FACE LOCK — Phase 1a · the film's first and last image

**Attach `assets/women.png` as the identity reference.** Same woman, no drift. The approved output
of this block is `assets/women-face.png`.

Create one cinematic close portrait of the same woman as @image1, wide 16:9.

Tight close-up on her face — the frame holds her eyes, brows and the bridge of her nose, cropping the top of the head and the chin. She looks **straight down the lens**, level, direct, calm, unsmiling. Not pleading, not sad, not performing. A person who has been waiting a long time and is simply looking.

Real skin at close range: visible pores and fine texture, light freckling, a soft natural flush on the cheek, a few loose copper hairs across the temple. Clear soft green to grey-green irises with real detail in the iris fibre. No makeup, no retouching, no smoothing.

LIGHT — this is the whole point of the shot. Cold blue-grey light before sunrise, low contrast, no direct sun on the skin. **One single small warm catchlight** sits in each eye — a low point of gold, the only warm thing in the entire frame, as if the sun were somewhere she can see and we cannot. Everything else stays cool.

Filmic live-action photography, shallow but not soft focus, eyes critically sharp, natural light, organic 35mm film grain, matte.

Do not include: soft-focus beauty portrait, smoothed or airbrushed skin, makeup, styled hair, tears, averted eyes, head tilt, coy expression, warm overall grade, golden hour on the face, multiple scattered catchlights, ring-light reflection, second person, hands, text, watermark.

---

## THE EYES — three video passes · rendered OUTSIDE Director

These are the film's first and last images and they are **not** trusted to Director. Only the
full-body `@woman` goes into the Director run, so let Director render its own version of the eyes as
a timing placeholder, then **overwrite all three with these** in the edit. Registering the face as a
second Character is what breaks the one-person rule, so it stays out.

**All three: attach `assets/women-face.png` as the reference / first frame.** Image-to-video, 16:9.
Identical framing every time — only the light changes across the film. Render them in one sitting so
they match.

**A Character now exists in OpenArt for the face as well as the full figure.** That is fine and it
belongs here — but attach it **only** to these three passes. It must stay out of the Director run:
two Characters of the same woman is the most likely way to make Director cast two people and break
the film's one-person rule. For these passes the raw still as the first frame is tighter than a
character tag anyway, so use the image and treat the Character as a backup.

**Real durations, from the locked Director scene plan.** Section 1 is **00:00–00:33 (33 s)**, section 6
is **02:07–02:20 (13 s)**, section 9 is **03:27–03:57 (30 s)**. No video model will give you a
33-second locked close-up in one generation, so each pass is **several clips of the same prompt
stitched in the edit**. Cut on the blinks — a cut from eye to identical eye is invisible if it lands
mid-blink, and it is the one place in this film where an invisible cut is wanted. Render two or three
takes of each pass so you have blinks to choose from.

**A · section 1 — coldest · 33 s to fill**

```
Animate the attached portrait with almost no motion. Extreme close-up of her eyes, brows and the bridge of her nose, exactly as framed in the reference — do not reframe, do not zoom out, do not reveal more of the face. She looks straight down the lens, level, calm, unsmiling. The only movement in the entire shot: one slow natural blink, the faintest shift of the pupils, a single loose copper hair moving at the temple. The camera is locked, or creeps in by a few percent at most.

Light: cold blue-grey before sunrise, flat and shadowless, no direct sun on the skin. ONE small warm catchlight sits in each eye and holds absolutely steady — it is the only warm thing in the frame and it must not drift, flicker, multiply or bloom.

Filmic live-action, eyes critically sharp, real pores and fine skin texture, organic 35mm grain, matte.

Do not: reframe or pull out, turn or tilt the head, add a smile, add tears or wet eyes, warm the overall grade, add golden light on the skin, add extra catchlights or a ring-light reflection, morph the face, change her age, smooth or retouch the skin, add hands, text, watermark.
```

**B · section 6 — the same eyes, the light has moved · 13 s to fill**

Same reference, same framing. The whole point is that *she* has not changed and the light has, so
change nothing else.

```
Animate the attached portrait with almost no motion, identical framing to the reference — extreme close-up of the eyes, straight down the lens, calm and unsmiling. One slow blink and a micro shift of the pupils; the camera locked or creeping in by a few percent.

Light: the cold pre-dawn has given way to early morning. The catchlight in each eye is now WARMER and slightly larger, real gold; there is more warm detail in the iris fibre, and the skin is no longer purely cold blue-grey — a faint warmth has reached it. Still low contrast, still no direct sun, still no hard shadow. Restrained: this is the light changing, not a golden-hour portrait.

Filmic live-action, eyes critically sharp, real skin texture, organic 35mm grain, matte.

Do not: reframe or pull out, change the angle of her head, change her face or age, smile, tears, heavy warm grade, sunlight striking the skin, lens flare, extra catchlights, smoothed skin, hands, text, watermark.
```

**C · section 9 — the outro, dark and quiet · 30 s to fill, hold to the end of the audio**

This is the plate the gold-leaf stars get painted into, so keep the irises clean and readable and
**do not** let it fade out — the ending is made in the edit, not here.

```
Animate the attached portrait with almost no motion, identical framing to the reference — extreme close-up of the eyes, straight down the lens, calm, unsmiling. Very long steady hold. One slow blink at most; the camera is locked. Absolutely no cuts.

Light: dark and quiet, the darkest version of this shot in the film. Deep cool near-black surroundings, the face barely modelled, but the IRIS OF EACH EYE STAYS CLEARLY VISIBLE and in focus with real fibre detail — the eyes are the only lit thing. One small steady catchlight in each. Nothing else in the frame.

Hold at full brightness all the way to the last frame. Do NOT fade to black, do not darken toward the end, do not resolve or conclude the shot.

Filmic live-action, eyes critically sharp, real skin texture, organic 35mm grain, matte.

Do not: fade out, fade to black, vignette closing in, close her eyes at the end, reframe or pull out to a landscape, add stars, sparkle, glitter, bokeh lights or any painted element (those are added by hand afterwards), tears, smile, warm grade, hands, text, watermark.
```

---

## DRAWN STYLE A — Phase 1b · ornament inside the painting

No reference image. This is the style candidate, so let it be its own thing.

Create one hand-drawn 2D animation background painting, wide 16:9, no people and no animals.

One great wild cherry tree in absolutely full blossom, standing alone on a rough Irish hillside beside a narrow stone lane, low green hills and a river valley behind it. **A sunshower** — bright low sunlight and falling rain at the same moment. The rain is **drawn as visible slanted lines** across the whole frame. Blossom petals come off the tree as **individual brush strokes** carried on the wet air. Everything gleams wet while the sun still strikes it.

MEDIUM — this matters more than the subject. Hand-painted gouache and watercolour on heavy paper. Visible paper tooth and texture through the paint. Brush edges, wet pigment pooling and blooming at the edges of forms, slight granulation, a few places where the paint is dry-brushed and the paper shows through. Painted light, not photographed light. The look of a hand-made animation background, made by a person with a brush.

CELTIC ORNAMENT — quiet, structural, never pasted on. The branches and roots twist with the interlace logic of Celtic knotwork, so the tree's own structure reads as ornament without becoming a pattern. No border, no frame, no decorative panel.

COLOUR — luminous and saturated, richer than any photograph: white and warm pink blossom, wet green hillside, cool grey-violet rain, gold where the sun cuts through the shower.

Do not include: anime or manga style, Japanese sakura park, cherry blossom festival, torii gate, lanterns, koi, kimono, Ghibli pastiche, cel-shaded gloss, hard black outlines, 3D render, CGI, photorealism, photographic rain blur, vector flatness, comic panels, decorative borders, gold frame, people, figures, silhouettes, animals, birds, text, watermark.

---

## DRAWN STYLE B — Phase 1b · illuminated manuscript

Same subject, different language. Generate both A and B, then pick one and never deviate.

Create one hand-made illuminated painting in the manner of an early medieval Celtic illuminated manuscript, wide 16:9, no people and no animals.

One great wild cherry tree in full blossom on a rough hillside beside a stone lane, with a river valley beyond, painted as a manuscript illumination: **flattened space**, stacked planes rather than photographic depth, forms drawn with a confident ink line and filled with flat luminous colour. **A sunshower** — sun and rain together, the rain drawn as fine ruled slanting lines, the petals as small deliberate strokes.

MEDIUM. Pigment and ink on vellum. Visible vellum grain and slight age in the ground. **Real gold leaf** in the sky and on the water, laid flat and slightly uneven, catching as metal rather than painted yellow. Deep lapis blue, ochre, verdigris green, iron-gall line work. The palette of a hand-ground pigment box.

CELTIC ORNAMENT is the language here, not a detail. Interlace knotwork runs through the branch structure and the roots, spirals and triskele forms in the hill contours, and the whole image sits inside a woven interlace border with knotwork corners. Ornament and landscape are the same drawing.

Beautiful, devotional, luminous. A page made by hand, not a print of one.

Do not include: anime or manga style, Japanese sakura, sakura festival, torii, kimono, Ghibli pastiche, 3D render, CGI, photorealism, airbrush, gradient mesh, vector cleanness, printed reproduction look, scanned book page with modern typography, text, lettering, calligraphy, letterforms, initials, people, figures, saints, animals, birds, watermark.

---

## GLEN — the wide valley, cherries bare

**Attach `assets/lane.png`.** That plate owns the cottage, the door, the walls, the gate and the
tree beside the lane; this one has to be the same place seen from across the valley. Save as
`glen.png`.

**The AI's usual miss:** it drops the cottage into the landscape and invents trees elsewhere, or
puts the landmark cherry halfway down the lane with empty space around the house. The
cottage-and-tree pair must stay together — they are one unit in `lane.png` and they must stay
one unit here.

Create one empty wide landscape plate of the same place as the attached image, seen from far off, 16:9. Photoreal filmic live-action, not painted.

A narrow glen in the west of Ireland seen WIDE from the opposite hillside, so the whole geography reads in one frame: the small single-storey grey stone cottage from the attached image at the top of the slope, the lane running downhill from its door, curving once, and ending at a five-bar timber field gate in a drystone wall, and below the lane a small river running over pale pebbles. Rough pasture in irregular fields divided by drystone walls, rushes in the wet hollows, a long ridge line closing the horizon. A big open sky over a small inhabited valley.

THE LANDMARK TREE MUST STAY NEXT TO THE COTTAGE. In the attached image a large leafless tree stands immediately beside the cottage, on the right of the lane, growing out of the stone wall by the house. In THIS wide plate that same tree must still sit RIGHT BESIDE THE COTTAGE — almost touching the gable, filling the space next to the house — not halfway down the lane, not near the gate, not alone in a field. If the cottage is visible, that tree must be visible next to it. This is the largest tree in the glen and the one nearest the house.

THE OTHER TREES. Wild cherry trees (gean), five to seven more of them, scattered through the rest of the glen and each standing ALONE with open space around it: two or three along the river, one or two in the corners of the walled fields, one high on the slope near the ridge. Self-sown and wind-shaped, leaning slightly, all different sizes and all SMALLER than the cottage tree. Never in a row, never clustered, never an orchard or a planted avenue. Never a tree standing where the cottage tree should be and leaving the cottage bare.

Every tree is BARE — fine leafless winter branches, dark against the grass — no blossom and no leaf anywhere. Place them clearly and legibly; their positions will be reused.

Light: cold grey overcast, no direct sun, wet ground, early spring before any growth.

Filmic live-action photography, natural light, organic 35mm film grain, matte.

Do not include: the cottage without its tree beside it, blossom, flowers, leaves, an orchard, rows or avenues of trees, dense woodland, conifers, people, animals, birds, other buildings, roads, vehicles, poles, wires, wire fences, signage, painted or illustrated look, warm sunset light, the sun disk, text, watermark.

---

## GLEN-BLOOM — the same valley in flower

**Attach the approved `glen.png` — that one only.** This is the live-action payoff and it must be
the same trees in the same places. Save as `glen-bloom.png`.

Create one empty wide landscape plate of the same valley as the attached image, from the identical viewpoint, 16:9. Photoreal filmic live-action, not painted.

Same glen, same viewpoint, same cottage at the top of the slope WITH its landmark cherry still hard beside the gable, same lane curving down to the same gate, same river below, same field walls and same ridge line as the attached image. Every wild cherry tree from the attached image is in the SAME position with the SAME silhouette and the SAME size — same number of trees, none added, none removed — and all of them are now in FULL WHITE BLOSSOM. The cottage tree stays the largest and stays next to the house. Small white five-petalled wild-cherry flowers in loose clusters on bare or barely-leafed twigs, reading at this distance as separate clouds of white standing in a green valley. Fallen petals pale on the wet stone of the lane, a few drifting on the river.

Light: soft bright spring daylight under broken cloud, patches of blue, the ground still soaked from rain with puddles bright in the lane ruts. The sun disk is NOT in frame.

Restrained and true, not a fantasy. Muted natural colour — the white of the blossom does the work, not saturation. Cooler and plainer than a painting would be.

Filmic live-action photography, natural light, organic 35mm film grain, matte.

Do not include: pink or candy-coloured blossom, Japanese sakura, sakura park or festival, an orchard or planted rows, any tree in a position where the attached image had none, a different viewpoint, a different valley, painted or illustrated look, HDR glow, heavy saturation, warm fake sunset, the sun disk, people, animals, birds, vehicles, text, watermark.

---

## GLEN-MIDNIGHT — same valley in blossom, full moon

**Attach the approved `glen-bloom.png` — that one only.** Same trees, same places, only the light
changes. Save as `glen-midnight.png`.

Create one empty wide landscape plate of the same valley as the attached image, from the identical viewpoint, 16:9. Photoreal filmic live-action, not painted.

Same glen, same viewpoint, same cottage, same lane, same gate, same river, same field walls and same ridge line as the attached image. Every wild cherry tree from the attached image stays in the SAME position with the SAME silhouette and the SAME size, still in FULL WHITE BLOSSOM — same number of trees, none added, none removed.

Only the light has changed: it is MIDNIGHT. A FULL MOON sits high in a clear deep-blue night sky, large enough to read as a disk, cool and silver. Moonlight rakes the white blossom so the flowers glow against black hills and black cottage stone. The river below holds a long broken moon-path on the water. Stars are present but SMALL and cold — pinpricks only, not decorative, not gold.

Deep night-blue and silver only. Quiet, cool, real. No warm colour anywhere.

Filmic live-action photography, natural moonlight, organic 35mm film grain, matte.

Do not include: pink candy blossom, Japanese sakura, sakura park, an orchard, any tree where the attached image had none, a different viewpoint, painted or illustrated look, golden moonlight, warm tungsten or orange colour, HDR glow, city light pollution, a second moon, gold-leaf stars, people, animals, birds, vehicles, text, watermark.

---

## RIVER — rebuild · cottage tree + cherries along the water

**Why rebuild:** the old `river.png` had scrub behind the cottage but no landmark tree
beside it, and the riverbank trees were thin scrub that will not read as wild cherry in blossom.
Archived as `not-used/river-no-cottage-tree.png`.

**Attach two refs:**
- `@image1` = `lane.png` — cottage + the landmark tree beside it (the lock)
- `@image2` = `glen.png` — how many cherries and where they sit in this glen

Save as `river.png`.

Create one empty landscape plate of the same Irish glen river, wide 16:9. Photoreal filmic live-action, not painted.

Viewpoint: low and close from the near bank of a small fast river, looking slightly uphill so the cottage and the gate are visible beyond the water. Same geography as the attached images — same cottage, same field gate, same drystone walls, same ridge line.

THE COTTAGE AND ITS TREE ARE ONE UNIT. Take the cottage from @image1 and keep its landmark leafless wild cherry RIGHT BESIDE it — almost touching the gable, on the cottage side of the lane, the largest tree in the frame. Do not leave the cottage standing alone. Do not put only scrub behind it. If the cottage is visible, that tree must be visible next to it.

ALONG THE RIVER: two or three more wild cherry trees (gean), each standing ALONE on the banks — not scrub, not alder thicket, not a hedge. Real trees with a clear trunk and a spreading crown of bare winter branches, sized so that when they blossom later they will read as white clouds over the water. One on the near bank if the composition allows, one or two on the far bank. Never in a row, never an orchard.

The river itself: fast shallow water over pale rounded pebbles and larger dark stones, broken into ripples. The near bank in the foreground is low, soft dark mud, wet and COMPLETELY UNMARKED — no footprints. Far bank steeper, grassy, with stone.

Every tree is BARE — leafless winter branches, no blossom and no leaf. Cold grey overcast or dusk light, wet ground.

Filmic live-action photography, natural light, organic 35mm film grain, matte.

Do not include: the cottage without its tree beside it, blossom, flowers, scrub only with no real trees, an orchard, dense woodland, pink sakura, people, animals, birds, footprints, tracks in the mud, painted or illustrated look, warm sunset, the sun disk, text, watermark.

---

## RIVER-MIDNIGHT — same river in blossom, full moon

**Attach the approved `river.png` — that one only.** That plate already holds the cottage, its
landmark cherry, the gate, the pebble bed and the clean mud bank. Only blossom and moonlight are
new. Save as `river-midnight.png`.

Create one empty landscape plate of the same river as the attached image, from the identical viewpoint, 16:9. Photoreal filmic live-action, not painted.

Same river seen low and close from the same near bank as the attached image: the same pebble bed, the same large dark stones in the water, the same low dark mud bank in the foreground, the same cottage with its tree up the slope on the left, the same field gate and drystone walls behind, the same hills and ridge line. Nothing moves position.

Every tree — the one beside the cottage and the ones along the water — is now in FULL WHITE BLOSSOM. Same trees, same places, same silhouettes as the attached image; only the flowers are new. Small white five-petalled wild-cherry flowers in loose clusters. A few fallen petals pale on the wet pebbles and drifting on the water.

It is MIDNIGHT. A FULL MOON hangs in a deep-blue night sky, large enough to read as a disk. Moonlight catches the white blossom so it glows against near-black banks, and lays a long broken moon-path down the running water. Wet pebbles and the river surface hold silver; the banks and the cottage stone stay very dark. Stars present but small and cold.

THE MUD BANK IN THE FOREGROUND IS SMOOTH, WET AND COMPLETELY UNMARKED — no footprints, no tracks, no marks of any kind.

Deep night-blue and silver only, quiet and real. No warm colour anywhere.

Filmic live-action photography, natural moonlight, organic 35mm film grain, matte.

Do not include: footprints, tracks or marks in the mud, pink candy blossom, Japanese sakura, sakura park, an orchard, any tree where the attached image had none, a different viewpoint, golden or warm moonlight, tungsten or orange colour, HDR glow, light pollution, a second moon, gold-leaf stars, painted or illustrated look, people, animals, birds, text, watermark.

---

## DRAWN-RIVER — rebuild from the new river plate

**Why rebuild:** the first `drawn-river.png` was painted from the old river plate, before the
cottage got its landmark tree and the banks got real cherries. Archived as
`not-used/drawn-river-old-geography.png`.

**Attach two refs:**
- `@image1` = `river.png` — geography: viewpoint, cottage + its tree, bank trees, gate, pebble bed
- `@image2` = `drawn-lane.png` — medium: the painted language the film already approved

Take the layout from the first and the medium from the second. Save as `drawn-river.png`.

Create one hand-painted 2D animation background of the same river as @image1, wide 16:9, no people and no animals.

GEOGRAPHY from @image1, unchanged: the same low close viewpoint from the near bank, the same fast shallow river running over pale rounded pebbles and larger dark stones, the same low soft mud bank in the foreground, the same small stone cottage up the slope on the left WITH ITS LARGE CHERRY TREE HARD BESIDE IT, the same large tree on the near bank, the same trees on the far bank, the same field gate and drystone walls behind, the same hills and ridge line. Nothing moves and nothing is added.

Every cherry is now in OVERWHELMING FULL BLOSSOM — fuller and whiter than any real tree, clouds of blossom over the water.

MEDIUM, matching @image2 exactly — this matters more than the subject. Hand-painted gouache and watercolour on heavy paper. Visible paper tooth and texture through the paint, brush edges, wet pigment pooling and blooming at the edges of forms, granulation, passages of dry brush where the paper shows through. Painted light, not photographed light. The water is drawn in confident strokes with white ripple marks; the pebbles are deliberate individual touches of colour; the petals on the surface are small brush strokes.

A SUNSHOWER: bright low sunlight and falling rain at the same moment, the rain drawn as visible slanted lines across the frame, everything gleaming wet while the sun still strikes it.

GOLD LEAF: scattered across the surface of the water, points of light laid in real gold leaf — flat, slightly uneven, catching as metal rather than painted yellow. Stars lying on the water.

CELTIC ORNAMENT, quiet and structural: interlace knotwork logic in the pattern of the ripples and in the roots along the bank. Never a border, never a pasted pattern.

COLOUR: luminous and saturated, richer than any photograph — white and warm pink blossom, wet green bank, cool grey-violet rain, gold where the sun cuts the shower.

THE MUD BANK IN THE FOREGROUND IS SMOOTH, WET AND COMPLETELY UNMARKED — no footprints of any kind.

Do not include: footprints or tracks in the mud, the cottage without its tree, photorealism, live-action photography, anime or manga style, Japanese sakura, sakura festival, torii, lanterns, kimono, Ghibli pastiche, cel-shaded gloss, hard black outlines, 3D render, CGI, photographic rain blur, vector flatness, comic panels, decorative border, gold frame, night, moon, people, figures, silhouettes, animals, birds, text, calligraphy, letterforms, watermark.

---

## DIRECTOR FULL TRACK — New Hope

**Engine: MiniMax H3 Max · 768P (~40 credits/sec) · 16:9**
Full song is **237 s (3:57)** ≈ **~9,500 credits**, plus planning and reference overhead.
Budget **11–12k for one full pass**. Planning steps burn tokens even when you reject the result —
there is no free reject. Do not use Seedance for the first pass; keep it for replacing peak shots.

**Attach:**
- Character: `@woman` — **one only**
- Locations: `@door` · `@lane` · `@cherry-bloom` · `@glen` · `@glen-bloom` · `@glen-midnight` · `@river-midnight` · `@drawn-lane` · `@drawn-river`
- **Do not attach `river.png`** — the live river only appears at midnight in section 8, and offering
  the daylight version invites a daylight river the film does not have. It is a base plate only.
- Audio: full `New-hope.mp3` (not trimmed)

**Setup:**
1. New Director → **Guide me** (never "Just make it")
2. Attach assets above + full audio (Character = the woman only; Locations = the nine plates)
3. Paste the brief below
4. Model → **MiniMax H3 Max** · Quality → **768P** · Aspect → **16:9**
5. Duration → **the full track**, do not let it propose 30–60 s
6. If it offers creative-direction chips → reply in chat, do not click:
   `Ignore creative direction chips. Use only the section script I pasted. No singer, no voiceover, no added music.`

**The repeat problem is worse here than on Poor man rose.** Verse 1 is sung twice word-for-word,
the bridge is sung twice word-for-word, and two of the three choruses differ by the single phrase
*"I wanna"*. Lyric matching alone will scramble the film, so the brief leads with a numbered
running order and tells Director to count sections rather than match words. The one reliable word
anchor is *"just behind your door"* — that phrase occurs in the second chorus and nowhere else.

Paste:

```
Full music video for the song "New Hope". Visual only — the song is already recorded. NO singer, NO performer on camera miming, NO lip sync, NO lyric captions, NO on-screen text, NO voiceover, NO added music or sound effects. Use the attached audio as the whole soundtrack.

ONE PERSON IN THE ENTIRE FILM: @woman. No second person anywhere, including background, reflections and silhouettes. No instruments, no musicians. Her hands are always empty. She wears scuffed brown leather ankle boots everywhere EXCEPT the midnight river in section 8, where she is barefoot — that is the only exception and it matters.

THE LOCATIONS, so the tags are unambiguous. All of them are the SAME small Irish glen seen differently: a grey stone cottage at the top of a slope with one large wild cherry hard beside its gable, a stone lane running down from its door to a five-bar field gate, a pebble river below the lane, eight scattered wild cherries through the valley, drystone walls, a long ridge closing the horizon.
- @door — the cottage gable and its shut timber door, straight on. Interior never visible.
- @lane — the lane from the cottage end looking down to the gate, cherry bare on the right.
- @cherry-bloom — the landmark cherry in white blossom beside the cottage door, lit, wet lane.
- @glen — the whole valley wide from the opposite hillside, every cherry BARE.
- @glen-bloom — that same wide valley, same trees, all in white blossom, soft day.
- @glen-midnight — that same wide valley in blossom under a full moon, silver.
- @river-midnight — the river low and close, blossom over black banks, full moon, moon-path on the water, mud bank clean.
- @drawn-lane — the lane and the cherry, HAND-PAINTED, sunshower, petals.
- @drawn-river — the river, HAND-PAINTED, gold on the water, empty mud bank.

TWO MEDIUMS. The waiting world is live-action photography. Behind the door is 2D hand-painted animation — the SAME Irish glen, redrawn. @door @lane @cherry-bloom @glen @glen-bloom @glen-midnight @river-midnight are live action. @drawn-lane @drawn-river are hand-painted. The two mediums NEVER appear in the same frame in anything you render — no exceptions. (The finished film does end on a single dual-medium frame, but it is painted by hand in the edit afterwards. Do not attempt it, do not plan for it, and do not put any painted element into the outro.) Cut between mediums hard — never cross-dissolve, never morph.

@woman IS NEVER DRAWN. There is no figure of any kind in the painted world — no person, no silhouette. The drawn sections are empty places.

THE SECTIONS REPEAT. Do not identify sections by their words — follow this running order and count:
1. VERSE — her eyes (the first time these words are sung)
2. CHORUS 1
3. VERSE — the door and the hundred steps
4. CHORUS 2 — the only chorus that sings "just behind your door"
5. BRIDGE 1 — the DREAM. This is the painted one.
6. VERSE — her eyes again, the SECOND time these exact words are sung
7. CHORUS 3
8. BRIDGE 2 — the REAL one. Live action. Same words as section 5, opposite meaning.
9. OUTRO — "Oh oh oh"
The two bridges are word-for-word identical. The FIRST is the painted dream, the SECOND is live and real. This is the spine of the film; do not swap them.

=== 1. VERSE — EYES · live · coldest light in the film ===
Extreme close-up of her face only: eyes, brows, bridge of the nose, top of head and chin cropped. She looks straight down the lens, level and calm, unsmiling — a person who has been waiting a long time and is simply looking. Real skin texture at close range. Camera locked or a micro push only. Light: cold blue-grey before sunrise, flat and shadowless, no direct sun. ONE small warm catchlight in each eye is the only warm thing in the frame.
"not forgotten / silence of hope" — hold the eyes. Longest hold of the opening.
"Sun is in your eyes / you are looking into my soul" — same framing, tiny life only, a blink is fine.
"yes eyes are like a mirror / asking where do we go" — hold, or the smallest push toward one eye.
Do not: cut away to landscape, turn her head, tears, warm grade on the skin.

=== 2. CHORUS 1 · live · first gold · @glen @lane · SUN DISK WITHHELD ===
The place revealed for the first time. Light: the sun is still below the ridge, the sky warming, the first gold touching only the top edges of stone and the cottage roof — cold shadows still winning. The sun itself must NOT be visible.
"New hope rising / like this morning sun with you" — wide @glen: the whole valley, cottage small at the top of the slope, the lane running down to the gate, the river below. The scattered cherry trees are all BARE here — leafless. They are being planted in the audience's eye for later; do not put a single flower on them.
"I find some peace / inside my dreams I saw I told you" — @lane, and she is in it but SMALL and distant, near the cottage end. Do not come close to her.
"the reason why your hopes are sailing with me" — @lane, the bare tree and wet stone, light still warming.
"Would you like to understand it too?" — hold on the empty lane looking down toward the closed gate. She has left the frame.

=== 3. VERSE — THE DOOR AND THE HUNDRED STEPS · live · no people at all ===
Nobody in this section. Back toward the cold light of section 1.
"Not forgotten, silence of hope" — @door straight on from a few paces back. The door is shut. The interior is not visible.
"Waiting just behind the door, heart full of thoughts" — @door, closer. Stay on the shut door. Do NOT open it, do not show what is behind it.
"Hundred steps away from you" — @lane from the cottage end looking down, so the whole length reads at once and is countable.
"End of the road" — the closed five-bar gate at the end of the lane. It reads as an ending, not an invitation.

=== 4. CHORUS 2 · live · @door · approach but DO NOT ENTER ===
The only chorus with the words "just behind your door". Still first-gold light, gold on the stone above the door, the door itself in shade. No people.
"New hope rising just behind your door" — @door is the subject, centred, shut.
"Find some peace inside my dreams I saw, I told you" — slow steady push toward the door.
"If I knew the reason why your hopes are sailing with me" — the push continues, closer, the timber grain and iron latch now readable.
"Would you like to understand it too?" — the push STOPS short of the threshold and holds. The door does not open in this section. Withholding it here is the point.

=== 5. BRIDGE 1 — THE DREAM · live, then PAINTED · the film's turn ===
First bridge. Starts live and grey, goes through the door, and comes out hand-painted.
"yeah... yeah I am / Waiting for a 'winter day'" — @lane, bare, cold grey overcast, leafless scrub. IT IS RAINING, and the rain is filmed ON THE WATER: frame the puddles and the flooded ruts large in the foreground, and show the rain as it lands — concentric rings spreading and overlapping, the surface dimpling and breaking, drips running off the stone walls. Do not try to show falling drops in the open air against the sky or the hillside; that reads as noise. The water surface carries the whole weather.
"Or Cherry blossom through the rain" — on the word "Or", the camera finally pushes through the closed door. The interior does not resolve into a room: the frame goes to near-black, at most one dim window. Inside that black, HARD CUT — and we are in @drawn-lane, hand-painted: the same cottage corner, the same lane running to the same gate, the cherry now in overwhelming blossom, sun and rain at once, petals drifting as brush strokes. This is the most saturated passage in the film.
"Then all the stars can shine bright in your dreams" — stay painted. Drawn sky, or gold light lying on the painted water. Petals and painted light may move; do not add rain particles on top of the painting.
— second movement, still painted —
"yeah... yeah I'm going down the river flow" — @drawn-river, painted water in visible brush strokes.
"Collecting pebbles and the stones" — the painted stones on the river bed, graphic and deliberate. NOT in a hand. Nobody picks anything up.
"Your footprints touched behind a midnight walk" — the painted mud bank, and it is COMPLETELY EMPTY. No footprints of any kind. The dream does not have them yet. Hold on the empty bank.
Do not: put any figure in this section, cross-dissolve between the mediums, add photographic rain particles on top of the painting.

=== 6. VERSE — EYES AGAIN · painted, then live · same words as section 1, warmer ===
The second time these exact words are sung. Hard cut out of the painted world back to live action.
"not forgotten / silence of hope" — hard cut: the last painted petals to live wet air over @lane, then straight back into her eyes.
"Sun is in your eyes / you are looking into my soul / eyes are like a mirror / where do we go" — the same extreme close-up as section 1, same framing, but the light has moved: warmer catchlights, more gold in the iris, the skin no longer purely cold. She has not changed. The light has.

=== 7. CHORUS 3 · live · FULL MORNING · the sun disk is finally allowed · she walks ===
The warmest photographed light in the film, and the only place the sun itself may appear. It must still be TRUE rather than triumphant, and it must stay less beautiful and less saturated than the painted bridge.
"New hope rising like this morning sun with you" — @lane with the sun clear of the ridge, long raking light down the wet stone. She comes around the gable of the cottage into the lane. Keep this WIDE.
"Find some peace inside my dreams I saw, I told you" — travel with her down the lane, wide, from behind or the side. Do not cut to a close-up of her walking.
"Would you like to understand it too?" — she is small, far down the lane toward the gate. Warmest live frame of the film.

=== 8. BRIDGE 2 — THE REAL ONE · live · same words as section 5 ===
Second bridge. Identical words to section 5, and it must look like the real world's answer to that dream: plainer, cooler, truer. Nothing painted in this section.
"yeah... yeah I am / Waiting for a 'winter day'" — @lane bare again, the SAME framing as the start of section 5, so the two bridges rhyme. Raining again, and again read on the water: rings and dimpling across the puddles in the ruts.
"Or Cherry blossom through the rain" — @cherry-bloom: the same single wild cherry, now in real white blossom. A SUNSHOWER in live action — low sun breaking through broken cloud rakes across the blossom and the top of the stone walls while it is still raining. Keep a puddle or the wet lane stone in the lower frame so the rain reads as rings on the water with the sun on them. The sun disk stays OFF frame. Photoreal, restrained, deliberately less lovely than the painted tree.
"Then all the stars can shine bright in your dreams" — pull back off the single tree to the WIDEST live frame in the film, @glen-bloom: the same whole valley from Chorus 1, from the same viewpoint, and every one of those bare cherries is now in full white blossom. The real world has kept the promise the dream made. Slow, one move, hold it. NO stars yet — they belong to the outro. Keep it restrained: muted colour, sun disk off frame, still less radiant than the painted bridge.
— second movement, live, midnight —
"yeah... yeah I'm going down the river flow" — open on the WIDEST night frame, @glen-midnight: the same whole valley from @glen-bloom, same trees still in white blossom, now under a FULL MOON. Silver moonlight on the flowers, a moon-path on the river below. Then descend into @river-midnight — the same river low and close, blossom glowing over black banks, moon-path running on the water.
"Collecting pebbles and the stones" — @river-midnight. SHE STEPS BAREFOOT into the shallow edge of the river, onto the pale pebbles. Low and close on her bare feet and the moonlit water, the pebbles clear under the surface, water breaking around her ankles. Wide enough to read as a person, not a macro detail. NO hands and NO fingers in frame — nobody picks anything up.
"Your footprints touched behind a midnight walk" — the payoff of the whole film: on @river-midnight's mud bank, BOOT PRINTS are already pressed into the mud. She is barefoot, so the prints are unmistakably NOT hers. She finds them and looks at them. She does not make them, and we never see who did. Hold.

=== 9. OUTRO · live · back to the eyes · the only dual-medium frame ===
"Oh oh oh oh oh / Oh oh oh oh" — return to the extreme close-up of her eyes, the film's first image. Dark and quiet. Hold; cut as little as possible.
"Then all the stars can shine bright in your dreams" — stay on her eyes and hold until the audio ends. Keep the frame clean and simple here; the final flourish is added afterwards in the edit, so do not invent an ending, do not pull out to a landscape, and do not fade to black early.

GLOBAL LOOK
Live action: filmic 35mm, natural light, organic grain, matte, muted restrained colour, west of Ireland in early spring. Painted: gouache and watercolour on heavy paper, visible paper tooth and brush edges, painted light, Celtic interlace logic in branches and stone but never a border or pasted pattern.
THE LIGHT ARC, in order: cold pre-dawn (1, 3, 6) → first gold with the sun hidden (2, 4) → grey wet (5, 8 openings) → painted sunshower, the most radiant passage (5) → full morning with the sun visible, once only (7) → low broken sun (8) → day blossom wide (8) → full-moon midnight blossom (8) → river night (8) → dark (9). Never put the sun disk in frame before section 7. The moon disk is allowed only in the midnight walk.
THE BLOSSOM ARC. The glen holds scattered wild cherry trees, and in live action they are BARE for the whole film until section 8 — that is what makes the wide valley in flower at the end of section 8 land. The only blossom before that is inside the painted dream in section 5, which is a different medium. Same trees, same places, every time.
RAIN IS FILMED ON THE WATER. Wherever it rains in live action, put standing water in the frame — puddles, flooded ruts, the river — and let the rain read as rings spreading on the surface, dimpling, breaking light, drips off stone. Never as streaks in the open air. It rains only in sections 5 and 8; everywhere else the ground is merely wet.
The painted world must stay more beautiful and more saturated than the best live frame. Real morning is true; only the dream is radiant.

DO NOT INCLUDE, anywhere
A singer or performer, lip sync, captions, subtitles, lyrics on screen, logos, watermark, a second person, anyone besides @woman, any drawn or animated version of her, instruments, musicians, heavy rain streaks across open air or sky, rain in any section other than 5 and 8, cross-dissolves between the two mediums, the sun disk before section 7, blossom on any live-action tree before section 8 — every cherry in sections 1 to 7 is bare, footprints in the painted section, anime or manga styling, Japanese sakura, sakura festival, torii, lanterns, kimono, Ghibli pastiche, cel shading, hard black outlines, 3D render, CGI, anything held in her hands, close-ups of hands or fingers, costume-drama styling, Celtic novelty jewellery, green novelty Irish clothing, modern objects, roads, vehicles, poles, wires, signage.
```

**Three things stay out of Director and get done in the edit:**
1. **The seed** — one second of drawn colour in the gap under the door during section 3. Composite
   from `drawn-lane.png`. Director will either ignore it or open the door; ask for neither.
2. **The stars** — drawn gold-leaf stars painted into her live irises on the last line of the outro.
   This is the film's only frame holding both mediums at once, and it is a paint pass, not a render.
3. **The eyes** — sections 1, 6 and 9 are rendered separately from `women-face.png` using the three
   passes in **THE EYES** above, then dropped over whatever Director produced. The face asset is
   deliberately not attached to the Director run: a second Character of the same woman is the most
   likely way to break the one-person rule. Let Director's version stand as a timing placeholder.

Rain overlays in the edit are now a fallback rather than the plan — the model renders rain striking
water convincingly, so the shot carries it as long as there is a puddle in frame.

**After render:** save as `director-full-minimax-768.mp4`, then review against the section spine in
`shot-list.md` before spending anything on replacements. Replace peak shots individually rather than
re-rolling the whole track. The eyes are already planned replacements; the other likely candidate is
the passage through the door in section 5, which is the moment Director is most likely to smooth into
a dissolve instead of the hard cut the film depends on.

**First thing to check in the storyboard, before credits:** that the two bridges did not swap.
Sections 5 and 8 are word-for-word identical, so if anything painted appears in section 8 the film's
whole argument inverts — the dream would be arriving *after* the real world kept its promise.

---

## Phase 1 — done

`women.png`, `women-face.png` and the drawn style are locked, and all seven plates are in `assets/`.
The blocks above are kept only for regenerating a reject. Live work continues in the Director brief.
