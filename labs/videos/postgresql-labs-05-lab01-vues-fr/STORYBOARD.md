---
format: 1920x1080
duration: 252s
message: "Avant de faire le Lab 01, comprendre ce qu'une vue montre, stocke ou ne stocke pas"
arc: objectif -> roadmap -> vue normale -> usages -> modèle SQL -> updatable/check -> matérialisée -> méthode de travail
audience: "débutants PostgreSQL après Pagila et clients GUI"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
---

## Video direction

- Palette: même cadre éditorial que les épisodes 03/04; bleu Atlantic pour concepts actifs, vert Pine pour confirmations, warning pour erreurs fréquentes.
- Typographie: Literata pour titres, Instrument Sans pour explications, Geist Mono pour SQL, noms de vues, fichiers et commandes.
- Motion grammar: roadmap progressive, diagrammes de flux, surfaces SQL reconstruites, aucune capture réelle.
- Keepout: la bande `y=880-1080` reste libre de contenu critique.
- Niveau: haut niveau seulement, pas correction complète du Lab 01.

## Frame 1 - Objectif du Lab 01

- scene: Titre de l'épisode et trois prérequis validés: `pagila`, utilisateur personnel, client SQL.
- voiceover: "Dans cet épisode, nous ouvrons le Lab 01 sur les vues PostgreSQL. Nous n'allons pas encore corriger les exercices. L'objectif est de comprendre la carte du lab, puis la différence entre une vue normale et une vue matérialisée."
- duration: 24s
- poster: 12s
- transition_in: cut
- status: built

## Frame 2 - Roadmap du lab

- scene: Carte en six étapes: vues simples, vues modifiables, `WITH CHECK OPTION`, vues multi-tables, vues matérialisées, refresh et performance.
- voiceover: "Le lab avance en plusieurs familles: vues simples, vues modifiables, sécurité avec WITH CHECK OPTION, vues multi-tables, vues matérialisées, puis refresh et comparaison de performance. Le livrable final sera un fichier solutions.sql."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: built

## Frame 3 - Une vue, c'est quoi ?

- scene: Une requête `SELECT` longue est rangée derrière le nom `customer_info`; le résultat se consulte comme une table virtuelle.
- voiceover: "Une vue normale, c'est une requête enregistrée sous un nom. On peut ensuite l'interroger comme une table virtuelle. Important: la vue normale ne stocke pas les lignes; PostgreSQL recalcule le résultat quand on la lit."
- duration: 32s
- poster: 16s
- transition_in: crossfade
- status: built

## Frame 4 - Pourquoi créer une vue ?

- scene: Trois cartes: simplifier, sécuriser, stabiliser. Exemples `film_catalog`, `public_customer_list`, `customer_info`.
- voiceover: "Pourquoi créer une vue? Pour simplifier une requête longue, pour cacher certaines colonnes sensibles, ou pour donner un nom stable à une présentation des données. Par exemple, customer_info peut cacher la complexité des jointures d'adresse."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: built

## Frame 5 - Vue classique: modèle mental

- scene: Diagramme tables Pagila -> `SELECT ... JOIN ...` -> `CREATE VIEW customer_info AS ...` -> `SELECT * FROM customer_info LIMIT 5;`.
- voiceover: "Le modèle mental est simple: les tables Pagila restent la source. La requête SELECT décrit ce qu'on veut voir. CREATE VIEW donne un nom à cette requête. Ensuite, SELECT étoile FROM customer_info LIMIT cinq lit la vue."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: built

## Frame 6 - Vues modifiables et CHECK OPTION

- scene: Deux colonnes: vue simple sur une table = parfois modifiable; vue avec jointures/agrégats = lecture seule. Badge `WITH CHECK OPTION`.
- voiceover: "Certaines vues simples peuvent être modifiables, surtout si elles viennent d'une seule table. Une vue avec des jointures ou des agrégats est généralement en lecture seule. WITH CHECK OPTION ajoute une règle: une modification ne doit pas faire disparaître la ligne de la vue."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: built

## Frame 7 - Vue matérialisée

- scene: Comparaison côte à côte: vue normale recalculée à chaque lecture; vue matérialisée stockée sur disque, rapide mais à rafraîchir.
- voiceover: "Une vue matérialisée est différente. Elle stocke physiquement le résultat d'une requête, par exemple des statistiques par catégorie dans film_stats. C'est souvent plus rapide pour lire, mais le résultat peut devenir ancien. Il faut le mettre à jour avec REFRESH MATERIALIZED VIEW."
- duration: 38s
- poster: 19s
- transition_in: crossfade
- status: built

## Frame 8 - Comment travailler le lab

- scene: Méthode en cinq étapes: ouvrir le SQL, exécuter une section, tester, noter, garder cleanup pour la fin.
- voiceover: "Pour travailler le lab, ouvrez Lab tiret 01 tiret Views point sql. Exécutez une section à la fois, testez chaque vue, lisez les messages d'erreur, et gardez la partie cleanup pour la fin. Le but n'est pas de copier vite, mais de comprendre ce que chaque vue rend plus simple."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: built
