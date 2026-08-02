import { readFile, writeFile } from "node:fs/promises";

const TOTAL_DURATION = 227.6;
const WIDTH = 1920;
const HEIGHT = 1080;

const segments = [
  [1, 0.3, 4.9, "À la fin de cette vidéo, votre poste Windows sera prêt pour les TP"],
  [1, 5.2, 11.8, "PostgreSQL Server, pgAdmin 4 et les outils en ligne de commande"],
  [1, 12.1, 19.6, "notamment psql, seront installés."],

  [2, 22.9, 30.0, "Avant de commencer, vérifiez trois prérequis."],
  [2, 30.4, 34.1, "Utilisez un compte autorisé à installer un service Windows"],
  [2, 34.3, 37.9, "gardez une connexion Internet stable"],
  [2, 38.1, 41.4, "et préparez un gestionnaire de mots de passe, ou une note privée."],
  [2, 41.7, 47.2, "Le mot de passe postgres ne sera pas affiché une seconde fois."],

  [3, 52.8, 60.2, "Ouvrez la page officielle postgresql.org, puis la rubrique Download, Windows."],
  [3, 60.4, 69.2, "Choisissez Interactive installer by EDB: c'est l'assistant graphique utilisé dans cette vidéo."],
  [3, 69.4, 76.5, "Téléchargez la dernière version stable et prise en charge pour Windows x86-64."],
  [3, 76.8, 82.8, "Évitez les versions de test. Pausez ici pour terminer le téléchargement."],

  [4, 86.4, 98.0, "Exécutez le fichier en tant qu'administrateur et acceptez la demande de Windows."],
  [4, 98.3, 108.3, "Conservez les dossiers proposés: cela évite les problèmes de droits et simplifie les prochains TP."],
  [4, 108.6, 115.9, "Dans Select Components, gardez PostgreSQL Server, qui exécute la base de données; pgAdmin 4, l'interface graphique; et Command Line Tools, qui contient notamment psql."],
  [4, 116.2, 123.6, "Stack Builder ajoute des pilotes et extensions; il reste optionnel pour le moment."],

  [5, 125.0, 137.5, "Sur l'écran Password, créez un mot de passe solide pour le superutilisateur postgres, saisissez-le deux fois et conservez-le."],
  [5, 137.8, 146.0, "Il protège le compte d'administration et sera demandé lors de la première connexion. Pausez ici avant de continuer."],
  [5, 146.3, 153.1, "Gardez ensuite le port 5432: c'est le port PostgreSQL par défaut."],
  [5, 153.4, 162.0, "Conservez aussi la locale proposée par Windows; elle définit notamment les règles de tri et de formatage du nouveau cluster."],

  [6, 166.0, 175.8, "Avant l'installation, relisez le résumé: composants, dossiers, port et locale."],
  [6, 176.0, 180.7, "Utilisez Back si une valeur est incorrecte; sinon, cliquez sur Next."],
  [6, 181.0, 188.7, "L'assistant copie les fichiers, initialise le cluster et démarre PostgreSQL comme service Windows. Attendez le message de réussite."],
  [6, 189.0, 195.0, "Sur le dernier écran, décochez Launch Stack Builder at exit, puis cliquez sur Finish."],
  [6, 195.3, 199.2, "Vous pourrez toujours ouvrir Stack Builder plus tard."],

  [7, 203.9, 211.0, "L'installation est terminée lorsque SQL Shell, psql, et pgAdmin 4 apparaissent dans le menu Démarrer."],
  [7, 211.3, 220.0, "Si la commande psql n'est pas reconnue dans un terminal ordinaire, ce n'est pas un échec: l'installateur ne modifie pas automatiquement le PATH."],
  [7, 220.3, 226.8, "Dans l'épisode suivant, nous utiliserons SQL Shell pour effectuer la première connexion."],
];

function wordsOf(text) {
  return text.trim().split(/\s+/);
}

function chunkWords(words, maxWords = 6) {
  const chunks = [];
  const chunkCount = Math.ceil(words.length / maxWords);
  const baseSize = Math.floor(words.length / chunkCount);
  let remainder = words.length % chunkCount;
  let offset = 0;
  for (let i = 0; i < chunkCount; i += 1) {
    const size = baseSize + (remainder > 0 ? 1 : 0);
    chunks.push(words.slice(offset, offset + size));
    offset += size;
    remainder -= 1;
  }
  return chunks;
}

function round(value) {
  return Number(value.toFixed(3));
}

function buildGroups() {
  const groups = [];
  let groupIndex = 0;

  for (const [frame, start, end, text] of segments) {
    const words = wordsOf(text);
    const chunks = chunkWords(words);
    const totalWords = words.length;
    const duration = end - start;
    let cursor = start;

    chunks.forEach((chunk, chunkIndex) => {
      const isLast = chunkIndex === chunks.length - 1;
      const chunkDuration = isLast ? end - cursor : duration * (chunk.length / totalWords);
      const groupStart = round(cursor);
      const groupEnd = round(cursor + chunkDuration);
      const step = chunkDuration / Math.max(chunk.length, 1);
      const captionWords = chunk.map((word, wordIndex) => ({
        id: `caption-word-${groupIndex}-${wordIndex}`,
        text: word,
        start: round(cursor + step * wordIndex),
        end: round(cursor + step * (wordIndex + 0.82)),
      }));

      groups.push({
        id: `caption-group-${groupIndex}`,
        frame,
        start: groupStart,
        end: groupEnd,
        text: chunk.join(" "),
        words: captionWords,
      });

      groupIndex += 1;
      cursor += chunkDuration;
    });
  }

  return groups;
}

function audit(groups) {
  const short = groups.filter((group) => group.end - group.start < 0.8);
  if (short.length) {
    throw new Error(`Caption groups under 0.8s: ${short.map((group) => group.id).join(", ")}`);
  }

  for (let frame = 1; frame <= 7; frame += 1) {
    const frameGroups = groups.filter((group) => group.frame === frame);
    for (let i = 1; i < frameGroups.length; i += 1) {
      const gap = frameGroups[i].start - frameGroups[i - 1].end;
      if (gap > 0.75) {
        throw new Error(`Caption gap over 0.75s in frame ${frame}: ${gap.toFixed(3)}s`);
      }
    }
  }

  const frame7Words = groups
    .filter((group) => group.frame === 7)
    .reduce((count, group) => count + group.words.length, 0);
  const frame7Wpm = (frame7Words / 24) * 60;
  if (frame7Wpm > 140) {
    throw new Error(`Frame 7 captions are too dense: ${frame7Wpm.toFixed(1)} WPM`);
  }
}

async function main() {
  const groups = buildGroups();
  audit(groups);

  const payload = {
    total_duration_s: TOTAL_DURATION,
    width: WIDTH,
    height: HEIGHT,
    groups,
  };

  await writeFile("caption_groups.json", `${JSON.stringify(payload, null, 2)}\n`, "utf8");

  const captionsPath = "compositions/captions.html";
  let html = await readFile(captionsPath, "utf8");
  html = html.replace(/data-duration="[^"]+"/, `data-duration="${TOTAL_DURATION}"`);
  html = html.replace(
    /var GROUPS = \[[\s\S]*?\];\s*var DURATION = [0-9.]+;/,
    `var GROUPS = ${JSON.stringify(groups)};\n  var DURATION = ${TOTAL_DURATION};`,
  );
  await writeFile(captionsPath, html, "utf8");
}

await main();
