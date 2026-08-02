---
format: 1920x1080
duration: 250s
message: "Avant de faire le Lab 02, apprendre a mesurer un plan avant de creer un index"
arc: objectif -> roadmap -> mesurer -> seq scan/index scan -> B-tree -> lire explain -> index avances -> methode
audience: "debutants PostgreSQL apres Pagila et le Lab 01"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
---

## Video direction

- Palette: meme cadre editorial que les episodes 03-05; bleu Atlantic pour concepts actifs, vert Pine pour confirmations, warning pour couts et compromis.
- Typographie: Literata pour titres, Instrument Sans pour explications, Geist Mono pour SQL, noms d'index, plans et fichiers.
- Motion grammar: roadmap progressive, plans d'execution reconstruits, comparaison avant/apres, diagrammes d'index inventes, aucune capture reelle.
- Keepout: la bande `y=880-1080` reste libre de contenu critique.
- Niveau: introduction preparatoire uniquement, pas correction complete du Lab 02.

## Frame 1 - Objectif du Lab 02

- scene: Titre de l'episode, prerequis valides et idee centrale: mesurer avant d'indexer.
- voiceover: "Dans cet episode, nous ouvrons le Lab 02: Indexes. Nous n'allons pas corriger les exercices. Le but est de comprendre la methode: demarrer PostgreSQL, verifier Pagila, lancer une requete, mesurer son plan, puis seulement creer un index."
- duration: 26s
- poster: 13s
- transition_in: cut
- status: animated
- src: compositions/frames/01-objectif-lab02.html

## Frame 2 - Roadmap du lab

- scene: Carte en sept etapes: inspecter, observer les index, mesurer, creer, comparer, optimiser, nettoyer.
- voiceover: "Le parcours du lab est simple. D'abord, on inspecte les tables Pagila. Ensuite, on observe les index deja presents. Puis on lance des requetes lentes avec EXPLAIN ANALYZE, on cree des index cibles, on compare les plans, on optimise une requete de reporting, et on garde le nettoyage pour la fin."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: animated
- src: compositions/frames/02-roadmap-lab.html

## Frame 3 - Pourquoi mesurer avant d'indexer

- scene: Un plan avant/apres avec execution time et rows removed; l'index n'est pas presente comme solution automatique.
- voiceover: "Un index n'est pas une decoration qu'on ajoute partout. Il accelere certaines lectures, mais il coute de l'espace et du travail pendant les ecritures. Dans ce lab, la discipline importante est donc: mesurer d'abord, noter le temps, lire le plan, puis choisir l'index qui correspond vraiment a la requete."
- duration: 32s
- poster: 16s
- transition_in: crossfade
- status: animated
- src: compositions/frames/03-mesurer-avant.html

## Frame 4 - Seq Scan vs Index Scan

- scene: Comparaison visuelle entre lecture ligne par ligne de `film` et acces direct par un index sur `title`.
- voiceover: "Quand PostgreSQL affiche Seq Scan, il parcourt la table ligne par ligne. Pour une recherche comme film point title egal ACADEMY DINOSAUR, c'est volontairement tres visible dans le lab. Avec un Index Scan, PostgreSQL utilise une structure triee pour aller beaucoup plus directement vers les lignes candidates."
- duration: 32s
- poster: 16s
- transition_in: crossfade
- status: animated
- src: compositions/frames/04-seq-vs-index.html

## Frame 5 - Creer un index B-tree simple

- scene: Court extrait SQL `CREATE INDEX idx_film_title ON film(title);`, puis meme requete relancee.
- voiceover: "Le premier index important est un B-tree simple sur le titre du film. L'extrait a retenir est CREATE INDEX idx_film_title ON film title. Apres creation, on relance exactement la meme requete avec EXPLAIN ANALYZE. Ce qui compte, c'est la comparaison, pas seulement la creation de l'objet."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: animated
- src: compositions/frames/05-index-btree.html

## Frame 6 - Lire EXPLAIN ANALYZE

- scene: Plan simplifie avec surlignages: node type, actual time, rows, rows removed, buffers, execution time.
- voiceover: "Pour lire EXPLAIN ANALYZE au niveau debutant, cherchez quelques reperes. Le type de noeud: Seq Scan, Index Scan, Hash Join ou Sort. Le actual time, qui donne le temps reel. Le nombre de lignes gardees ou retirees par le filtre. Avec BUFFERS, regardez aussi les pages lues ou deja en memoire. Et tout en bas, notez Execution Time."
- duration: 36s
- poster: 18s
- transition_in: crossfade
- status: animated
- src: compositions/frames/06-lire-explain.html

## Frame 7 - Indexes avances du lab

- scene: Trois mini-cas: fonction `UPPER(name)`, date `rental_date`, composite `(first_name, last_name)`.
- voiceover: "Le lab va ensuite plus loin. Un index fonctionnel peut correspondre a une condition comme UPPER name. Un index sur rental_date aide les tris, les filtres et les regroupements par date. Et un index composite, par exemple sur first_name puis last_name, se lit de gauche a droite: l'ordre des colonnes fait partie de la strategie."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: animated
- src: compositions/frames/07-indexes-avances.html

## Frame 8 - Methode de travail et suite

- scene: Checklist de travail: une section, un plan avant, un index, un plan apres, notes, cleanup.
- voiceover: "Pour travailler proprement, executez un bloc a la fois. Gardez les plans avant et apres, notez les temps, et expliquez pourquoi l'index aide ou n'aide pas. Ne gardez pas les index inutiles par habitude. A la fin seulement, utilisez les DROP INDEX IF EXISTS pour nettoyer votre base de test."
- duration: 26s
- poster: 13s
- transition_in: crossfade
- status: animated
- src: compositions/frames/08-methode-suite.html
