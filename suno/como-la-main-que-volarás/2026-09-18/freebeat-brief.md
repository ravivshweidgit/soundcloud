# Como la mano que alzarás — Freebeat brief

For https://freebeat.ai/music-video-generator

Source lyrics: `lyrics-final.md` (proper Spanish, fitted to the melody)
Meaning reference: `lyrics-final-en.md`

## Order of operations on that page

1. Audio in: **upload the WAV master**, do not paste the Suno link. See below.
2. Mode: **Storytelling**, and use **Expert Mode** rather than Fast Mode.
3. Reference images: upload **two** photos, one per figure, so the Character Bible locks
   both appearances. Two is the maximum the feature takes.
4. Lyrics: **paste manually** from `lyrics-final.md`.
5. Concept + style: paste the logline and style prompt below.
6. Ratios: pick 16:9 **and** 9:16 in the same render.
7. Render in **30–60 second segments**, not one full pass. Full-length single renders are
   the least reliable thing the tool does.

## Use Expert Mode, not Fast Mode

Fast Mode is one-click automation and will flatten this brief into a generic look. Expert
Mode runs six reviewable stages — Creative Concept, Casting, Director, Cinematography,
Motion, Post-Production — and every intermediate artifact can be inspected and
regenerated before you pay to render.

That maps onto this document almost exactly:

| Freebeat stage | What to feed it from here |
|---|---|
| Creative Concept | The logline and the arc (wait → turn → move) |
| Casting | The two reference photos, the silhouette/colour distinction |
| Director | The section plan — this is where the shot order gets set |
| Cinematography | The visual style prompt, plus locked-off early / travelling later |
| Motion | The ramp: camera still in verses, moving from Chorus 2 |
| Post-Production | Ratios, 1080p master, upscale only the approved cut |

The storyboard is reviewable per scene, so fix problems at the Director stage rather than
re-rolling a whole render.

## Remaining limits

- **Two characters is the ceiling.** Freebeat's own guidance is one or two. The man/woman
  symmetry sits exactly at that limit — do not add a third figure.
- **Long single renders drift.** Generate in 30–60 second segments rather than one pass.
- **No real-time preview.** Every look you check costs credits.
- **Export is a finished MP4**, not an editable project file. If you want to recut it
  later in a real editor, plan for that outside Freebeat.

## Suno link or uploaded file?

Freebeat does accept a Suno link and pulls the audio and metadata with no download step.
It is the fastest way in, and it is fine for throwaway tests.

For the real render, **upload the WAV**. Two reasons:

- **Beat detection is tighter on a raw file.** Freebeat builds the whole storyboard from
  its audio analysis — BPM, onsets, energy, section boundaries — so a compressed source
  degrades the one thing the tool is actually good at. Side-by-side testing showed raw
  files gave cleaner transition timing than linked compressed audio.
- **The video must carry the same master you distribute.** You are releasing through
  DistroVid, so the audio in the video should be byte-identical to the released track. If
  Freebeat pulls its own copy from Suno, you cannot guarantee that.

Freebeat normalises to LUFS-14 either way, so do not pre-normalise yourself.

## Language rule

Paste the **lyrics in Spanish**, but write every **prompt in English**. Freebeat's scene
planning reads English instructions far more reliably, while the lyrics need to stay in
the language that is actually sung.

Do **not** let it auto-extract the lyrics. That already failed on this song — Whisper
recovered `Pris, des, isa, oin, zumbi` and similar from the earlier take (see
`000-old/lyrics-extracted.md`). Auto-extract on sung Spanish will rebuild that garbage.

## Arc — the wait is the first act, not the whole film

Every decision to move has a wait in front of it. Keep that wait, then break it. The
verses are stillness, the choruses are the lift, and by the final repeats the stillness
is gone and the movement is the subject.

This is the line that separates it from the Harvoin video. There the wait never resolves:
the figure stays, the camera retreats. Here the wait is a held breath that ends. Same
river, opposite conclusion.

| Stage | Where | What the frame does |
|-------|-------|---------------------|
| Wait | Verses 1–2 | Stillness, long holds, the figure fixed while the water moves past |
| Turn | Verse 3 | The grip loosens, the frame empties, the stillness stops being a choice |
| Move | Choruses, stronger each repeat | The hand rises, the body follows, the camera travels with it |

**This is a ramp, not a switch.** Do not make every verse equally still and every chorus
equally moving — that reads as a pendulum and the ending lands no differently from the
opening. Each pass has to sit further along than the last:

- Verse 1 frozen → Verse 2 stalled but the light is rotating → Verse 3 letting go.
- Chorus 1 the body only, camera locked → Chorus 2 the lift completes, camera starts to
  move → Final chorus the camera travels with the figure.

A verse that comes after a chorus never resets to the stillness of Verse 1.

## Logline (concept field)

Someone has stood at a riverbank long enough for the light to turn all the way around.
This is the morning they stop waiting — they lift their own hand and begin to move with
the water instead of watching it pass. The stillness at the start is real, and it is what
makes the movement at the end mean anything.

## Visual style prompt

Warm Iberian river landscape at the edge of day. Wide slow river, pale stone and dry
grass shore, reeds, low scrub, distant hills. Blue pre-dawn opening out into amber
golden hour as the song goes on — light that warms and rises rather than fades. Natural
light only, soft haze, 35mm film grain, warm palette. Camera locked off and holding in
the verses, then travelling and tracking in the choruses. Patient at first, opening up.
No text, no logos, no crowds, no modern city.

## Characters — two banks, one river

A man on one bank, a woman on the other. They never meet and never cross. The lyric
supports this directly: there is an `I` and a `you` in the song, the `you` is somewhere
the speaker cannot reach (`El río sigue, pero no estás`), and the chorus is one of them
telling the other they will rise.

Both are shot mostly back-view, silhouette, or from the shoulders down. Plain clothes, no
era detail. Hands are the subject more than faces — keep returning to the hand, the
wrist, the open palm.

Tell them apart by **silhouette and colour**: different coat length, different tone (one
darker, one lighter). Identity should survive at a distance without a face.

**Use the reference images.** Freebeat's Storytelling mode accepts one or two reference
photos and builds a "Character Bible" from them that locks appearance across shots.
Upload two — one per figure. Two is also the documented maximum, so this cast size is
exactly at the edge of what the feature supports. Do not add a third person.

**The eyes.** An extreme close-up — eyes and brow only, no full face — is the safest
identity shot there is, because there is no whole face for the viewer to check against.
Four such shots total: both pairs shut in Verse 2, both opening in Chorus 2, all in
matched framing so the cuts rhyme.

### Never in the same frame

This is the hard rule, and it is not stylistic — it is what makes the tool behave.

Freebeat's Storytelling mode is trained on conventional narrative footage, where two
people sharing a frame interact. Give it a shot containing both and it will generate a
couple: reaching, clasping hands, running toward each other, face-to-face close-ups. It
did all of those. Negative instructions like "never touch" are the weakest kind of
constraint for these models, and every re-render rolls the dice again.

So the constraint moves from the prompt into the structure. If a scene only ever contains
one person, there is nobody to pair them with, and the failure becomes impossible rather
than discouraged. The mirror lives in the edit — matched single shots cut back to back.

### The symmetry has to break

This is what keeps it out of Harvoin's territory. That video also puts two figures on
opposite banks — but there they never meet **and never move**, and the symmetry holds to
the end as shared paralysis. Here the mirror is exact through the wait and the first
lift, and then it splits: both move, in opposite directions along their own banks.

Same idea, opposite meaning. Harvoin symmetry is a trap. This one is a release.

## Section plan

Feed this at the **Director** stage, where the storyboard is reviewable per scene.

**One person per scene. No exceptions.** The `Who` column says who is in the frame, and
nobody else is. There is no wide shot containing both — that single shot is what kept
generating the couple, the hand-holding, and the face-to-face confrontation. The
symmetry is built by *cutting* between matched single shots, not by composing them
together. If Freebeat proposes a scene with two people in it, reject that scene.

| Section | Who | Lyric | Visual |
|---------|-----|-------|--------|
| Verse 1 | Man | Dejaste sombra frente a lo que quieres | His shadow alone, thrown toward the water on his bank. The shadow arrives before the person. |
| Verse 1 | Nobody | Si es tan clara como el agua | Clear water over pebbles, light refracting. No people in frame. |
| Verse 1 | Woman | El río sigue, pero no estás / Si hoy estás en la orilla | Her alone at the water's edge, completely still, facing the current. The wait, stated plainly. |
| Chorus 1 | Man | Como la mano que alzarás | His hand begins to rise into empty sky, one open palm. He does not finish the movement. |
| Chorus 1 | Woman | Como la mano que alzarás | Her hand doing the same, identical framing and speed. The cut is what makes them rhyme. |
| Chorus 1 | Nobody | No necesitas alas / No necesitas más | Bare sky. Nothing in frame at all. |
| Verse 2 | Man | De tarde o de madrugada | **Plant:** extreme close-up, his closed eyes, warm light moving across the lids. |
| Verse 2 | Woman | De tarde o de madrugada | The same extreme close-up, her closed eyes, matched framing. |
| Verse 2 | Nobody | Tu camino se decide hoy | An empty dirt track along a bank. Footprints stopping short. No one walking it. |
| Verse 3 | Man | Por si alguna vez aguantas | His hand closed hard on a reed. Holding on, and it is costing something. |
| Verse 3 | Woman | Por si alguna vez aguantas | Her hand closed hard on wet stone. Matched. Then both hands, in their own shots, open and let go. |
| Verse 3 | Nobody | Ya no, no, no me cuidas más / Sigue el río sin ti | The emptiest frame in the film — the river alone, both banks bare. The hinge. |
| Chorus 2 | Man | (repeat) | **Payoff:** his eyes opening into the sunrise, matched to Verse 2. Then his hand fully raised. |
| Chorus 2 | Woman | (repeat) | Her eyes opening, matched. Then her hand fully raised. Camera moves for the first time. |
| Final chorus | Man | (repeat) | He walks away along his own bank. Camera travels with him. Light at its warmest. |
| Final chorus | Woman | (repeat) | She walks the opposite direction along her own bank. Camera travels with her. |
| Final chorus | Nobody | last `No necesitas más` | The empty river, still running. They were never in the same frame, and both left. |

## Notes on meaning (so the AI does not invent the wrong story)

- **The raised hand is not a greeting, a wave, a blessing, or a protest fist.** It is a
  person lifting themselves. Reaching upward, open palm, no audience.
- **`No necesitas alas` means wings are what you do NOT need.** Generate no wings, no
  angels, no feathers, no birds standing in for the person. The whole point of the chorus
  is rising without them. This is the single most likely thing for the model to get
  backwards.
- **`te elevarás` is reflexive — you lift yourself.** No hand reaching down from above,
  no other person lifting them, no rescue, no rope, no ladder.
- **Everything is future and conditional.** `alzarás`, `te elevarás`, `te encontrarás`.
  The film ends on movement beginning, not on arriving anywhere. No reunion, no
  destination reached, no one waiting at the end of the path.
- **`en la orilla` is the bank, not a crossing.** No bridge crossed, no swimming across,
  no boat. Each stays on their own side. The movement is *along* the river and upward,
  never to the other side, and the two never touch, wave, or acknowledge each other.
- **They are not a couple being separated.** No romance beat, no reaching for each other,
  no longing glance across the water. The mirror is there because they are doing the same
  thing alone, at the same time — not because they want to reach each other.
- **The river is the direction, not the scenery.** Early on it passes a figure who will
  not move, and that contrast is the point. By the end the figure moves with it. Never a
  voyage or a boat trip; the water sets the direction the body finally takes.
- **Do not cut the wait short.** Verses 1 and 2 have to feel genuinely stalled, or the
  lift in the choruses has nothing to push against. The stillness earns the movement.
- `Ya no, no, no me cuidas más` is the only bitter line, and it is the hinge of the film.
  Empty the frame there and let the hand open. Everything after it moves.
- **The eyes opening is a decision, not an awakening.** No one is waking up, being
  healed, or being blessed. Keep it plain: lids open, light already there, no tears, no
  smile, no god-rays. It rhymes with the hand — both are things this person does for
  themselves.

## Avoid

wings, angels, feathers, halos, religious iconography, god-rays or divine light beams,
raised fists, waving, crowds, dancing, concert stage, lip sync, burned-in lyrics or
subtitles, boats crossing, bridges being crossed, waking from sleep, tears, beatific
smiles, the two figures meeting, embracing, waving to each other or locking eyes across
the water, flamenco or bullfighting clichés, sombreros, tropical resort scenery, neon,
cityscape, cars, fantasy creatures, sunset postcard oversaturation.
