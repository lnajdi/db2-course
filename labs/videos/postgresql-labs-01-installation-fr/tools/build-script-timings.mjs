import { readFileSync, writeFileSync } from "node:fs";

const script = readFileSync("SCRIPT.md", "utf8");
const lines = [...script.matchAll(/^ {4}(.+)$/gm)].map((match) => match[1].trim());
const durations = [22.73, 29.69, 33.63, 38.65, 41.05, 37.88, 7.65];
const speechWindows = [
  [[0.28, 1.52], [6.33, 19.57]],
  [[0, 0.92], [6.52, 24]],
  [[0, 1.16], [2.5, 3.06], [5.73, 30.08]],
  [[0, 0.73], [2.08, 3.4], [8.65, 36.3]],
  [[0, 0.83], [3.2, 5.15], [7.62, 8.15], [11.2, 36.9]],
  [[0, 1.2], [6.22, 32.88]],
  [[0, 0.92], [5.94, 7.59]],
];

if (lines.length !== durations.length) {
  throw new Error(`Expected ${durations.length} narration lines, found ${lines.length}.`);
}

function wordsFor(text, windows) {
  const tokens = text.match(/\S+/g) ?? [];
  const totalSpeech = windows.reduce((total, [start, end]) => total + end - start, 0);
  const slot = totalSpeech / tokens.length;

  return tokens.map((token, index) => {
    const wordStart = index * slot;
    const wordEnd = (index + 0.84) * slot;
    let offset = 0;
    let start = windows[0][0];
    let end = windows[0][0] + Math.min(slot * 0.84, windows[0][1] - windows[0][0]);

    for (const [windowStart, windowEnd] of windows) {
      const windowLength = windowEnd - windowStart;
      if (wordStart < offset + windowLength) {
        start = windowStart + wordStart - offset;
        end = Math.min(windowEnd - 0.01, windowStart + wordEnd - offset);
        break;
      }
      offset += windowLength;
    }

    return {
      text: token,
      start: Number(start.toFixed(3)),
      end: Number(Math.max(start + 0.03, end).toFixed(3)),
    };
  });
}

const voices = lines.map((text, index) => ({
  frame: index + 1,
  path: `assets/voice/voice_002_scene_${String(index + 1).padStart(2, "0")}.wav`,
  duration_s: durations[index],
  words: wordsFor(text, speechWindows[index]),
}));

writeFileSync(
  "audio_meta.json",
  `${JSON.stringify({
    tts_provider: "external",
    voice_id: "teacher-wav-final",
    timing_source: "script-aligned",
    bgm: null,
    bgm_pending: false,
    bgm_provider: null,
    bgm_pid: null,
    bgm_log: null,
    bgm_mode: null,
    bgm_target_duration_s: null,
    bgm_seed_duration_s: null,
    voices,
    sfx: [],
    total_duration_s: 211.28,
  }, null, 2)}\n`,
  "utf8",
);
