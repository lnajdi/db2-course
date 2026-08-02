import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";

const source = resolve(process.argv[2] ?? ".media/audio/voice/voice_002.wav");
const outputPrefix = resolve(process.argv[3] ?? ".media/audio/voice/voice_002_scene");
const cuts = [0, 22.73, 52.42, 86.05, 124.7, 165.75, 203.63, 211.28];

const input = readFileSync(source);
const sampleRate = input.readUInt32LE(24);
const channels = input.readUInt16LE(22);
const bits = input.readUInt16LE(34);
const bytesPerSecond = sampleRate * channels * (bits / 8);

for (let index = 0; index < cuts.length - 1; index += 1) {
  const dataStart = 44 + Math.round(cuts[index] * bytesPerSecond);
  const dataEnd = 44 + Math.round(cuts[index + 1] * bytesPerSecond);
  const pcm = input.subarray(dataStart, dataEnd);
  const wav = Buffer.alloc(44 + pcm.length);
  input.copy(wav, 0, 0, 44);
  wav.writeUInt32LE(36 + pcm.length, 4);
  wav.writeUInt32LE(pcm.length, 40);
  pcm.copy(wav, 44);
  const target = `${outputPrefix}_${String(index + 1).padStart(2, "0")}.wav`;
  mkdirSync(dirname(target), { recursive: true });
  writeFileSync(target, wav);
  console.log(`${target} ${(pcm.length / bytesPerSecond).toFixed(2)}s`);
}
