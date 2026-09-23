# Let the river flow — Suno covers, measured

Files in `mp3/`. Measured with ffmpeg + numpy (tempo grid, 16-step accent map per bar, band
energy, loudness). This is rhythm and sound only. Vocal quality and melody still need ears.

| File | Length | Tempo | Key | Loudness | Groove |
|---|---|---|---|---|---|
| `let the river flow.mp3` | 3:00 | 100.0 BPM | C major | -9.6 LUFS | Half-time backbeat, syncopated bass, punchy |
| `Let the River Flow (1).mp3` | 3:44 | 100.0 BPM | C major | -13.9 LUFS | Straight four-on-the-floor, 8th-note pulse |
| `Dancing in the Rain.mp3` | 3:58 | 100.0 BPM | C major | -14.3 LUFS | Straight four-on-the-floor, backbeat on 2 |

All three hold a rock-steady 100 BPM from start to end and stay in C major, the source key.

## 1. `let the river flow.mp3` — the one with character

- **Half-time feel.** Strongest hit on beat 3, next on beat 1, beats 2 and 4 light. That is
  kick on 1, snare on 3: the song feels like 50 BPM of weight on a 100 BPM grid.
- **Syncopated bass.** Bass accents on beat 4, the "and" of 2, beat 3 and the "and" of 4,
  with gaps between. Off-beat, stop-start, already close to the Queen-style bass idea.
- **Punchy and spacious.** Hits stand 6.6x above the average level (the other two: 3.3x).
  Lots of silence between hits.
- **Heavy and dark.** 60% of the energy is below 250 Hz. Least treble of the three.
- **Shape.** Full energy, breakdown from about 1:10 to 1:50, full again to the end.

## 2 and 3. `Let the River Flow (1)` and `Dancing in the Rain` — straight dance-pop

- **Four-on-the-floor.** Even hits on every beat plus the 8th notes between: the steady
  disco / dance-pop pulse.
- **Bass on the beat.** Root notes on 1, 2, 3, 4. Pumping, not syncopated.
- **Denser and brighter.** Less space between hits, more synth and mid-range, more treble.
- **Quieter.** About -14 LUFS, 4 dB below cover 1. Streaming normalises to about -14 anyway,
  so this is not a flaw, but cover 1 will hit harder on club systems.
- `Dancing in the Rain` pushes beat 2 a little harder, so it has more backbeat snap than (1).

## Recommendation

**Decision: style E (synth-pop, `styles-dance-pop.md`) stays the winner by ear.** The
half-time groove style below is an optional experiment, not the plan.

For rhythm, build on **cover 1**. Its half-time backbeat and off-beat bass are the most
distinctive groove of the three, and they are already halfway to the stop-start bass.

Suno can cover a Suno song. Upload `let the river flow.mp3` as the source and use the style
below, which describes the groove it already has, so Suno keeps it and adds the synth-pop
sheen of style E. If cover 1's melody or vocal is weaker than the others, do the opposite:
take the best-sounding of 2 or 3 and paste this style to pull its groove toward cover 1.

```
80s synth-pop cover with a half-time funk groove, steady 100 BPM, 4/4, keep the original melody, phrasing and vocal speed. Intimate breathy female lead vocal, bright catchy chorus, clear American English diction, layered harmonies on the hooks. Half-time drums: deep kick on beat 1, big dry snare on beat 3. Syncopated off-beat bass line with short notes and gaps, bass loud and upfront. Punchy, spacious and dry, lots of silence between hits. Shimmering synth pads, glassy synth arpeggios and a bright synth hook on the choruses only. Heavy warm low end, polished radio mix. Cool, confident, strutting, nostalgic. Avoid: four-on-the-floor, busy hi-hats, dense wall of synths, EDM drop, trap, rap, country, rock.
```

712 characters.

For straight dance-floor energy instead, covers 2 and 3 are already the right beat. Keep
style E as is and add `punchy dry drums, more space, heavy sidechain` to give them cover 1's
punch.
