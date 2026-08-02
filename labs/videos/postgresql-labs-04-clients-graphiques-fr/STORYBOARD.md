---
format: 1920x1080
duration: 300s
message: "Connecter Pagila avec trois clients graphiques en réutilisant les mêmes paramètres"
arc: objectif -> modèle commun -> trois démonstrations -> choix -> dépannage -> clôture
audience: "débutants Windows après la préparation de Pagila"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
---

## Video direction

- Palette: même cadre éditorial que les épisodes 02 et 03; bleu Atlantic pour les actions et champs à copier; vert Pine pour les confirmations; warning seulement pour le dépannage.
- Typographie: Literata pour les titres, Instrument Sans pour les explications, Geist Mono pour paramètres, requêtes SQL, identifiants d'extension et commandes.
- Motion grammar: révélations calmes, surfaces graphiques reconstruites, pas de captures réelles, pas de logos.
- Keepout: la bande `y=880-1080` reste libre de tout contenu critique pour les sous-titres.
- Tous les clients se connectent au même serveur local: host `localhost`, port `5432`, database `pagila`, user `karim`, mot de passe privé.

## Frame 1 - Objectif

- scene: Titre de l'épisode et promesse: après `psql`, découvrir les clients GUI, connecter `pagila`, lancer une première requête.
- voiceover: "Dans les épisodes précédents, nous avons déjà utilisé psql, le client en console. Dans cet épisode, nous passons aux clients graphiques, aussi appelés clients GUI. L'objectif est simple: connecter pagila avec votre utilisateur personnel, par exemple karim, et garder postgres pour l'administration."
- duration: 24s
- poster: 12s
- transition_in: cut
- status: built

## Frame 2 - Même serveur, trois clients

- scene: PostgreSQL Server au centre; `psql` marqué comme client déjà utilisé, puis `pgAdmin`, `DBeaver` et `VS Code` comme clients GUI autour.
- voiceover: "Un client GUI est seulement une interface graphique pour parler au serveur PostgreSQL. psql faisait déjà ce travail dans la console; pgAdmin, DBeaver et VS Code le font avec des boutons, des formulaires et des grilles. Le serveur, le port et les identifiants restent les mêmes."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: built

## Frame 3 - Paramètres communs

- scene: Fiche de connexion réutilisable: `localhost`, `5432`, `pagila`, `karim`, mot de passe privé.
- voiceover: "Avant d'ouvrir les logiciels, mémorisez les paramètres communs: hôte localhost, port cinq quatre trois deux, base pagila, utilisateur karim comme exemple. Remplacez karim par votre prénom en minuscules."
- duration: 34s
- poster: 16s
- transition_in: crossfade
- status: built

## Frame 4 - pgAdmin

- scene: Flux reconstruit pgAdmin: Register Server, onglet Connection, Query Tool, puis `SELECT * FROM film LIMIT 10;`.
- voiceover: "Dans pgAdmin, enregistrez un nouveau serveur: donnez-lui le nom Pagila local, puis dans l'onglet Connection, saisissez localhost, cinq quatre trois deux, pagila, votre utilisateur et votre mot de passe. Ouvrez Query Tool et lancez SELECT étoile FROM film LIMIT dix."
- duration: 46s
- poster: 22s
- transition_in: crossfade
- status: built

## Frame 5 - DBeaver

- scene: Flux reconstruit DBeaver: New Database Connection, PostgreSQL, Test Connection, table `film`, filtre `rating = 'PG'`.
- voiceover: "Dans DBeaver Community, créez une nouvelle connexion PostgreSQL avec les mêmes paramètres, testez la connexion, puis terminez. Dans l'arborescence, développez pagila, Schemas, public, Tables, ouvrez film, et filtrez les lignes avec rating égal à PG."
- duration: 44s
- poster: 20s
- transition_in: crossfade
- status: built

## Frame 6 - VS Code

- scene: Extensions VS Code: PostgreSQL for Visual Studio Code par Microsoft, id `ms-ossdata.vscode-pgsql`; connexion; fichier `queries.sql`; requête PG.
- voiceover: "Dans VS Code, cherchez PostgreSQL for Visual Studio Code, par Microsoft. L'identifiant est ms tiret ossdata point vscode tiret pgsql. Après l'installation, ajoutez une connexion PostgreSQL avec les mêmes paramètres, créez queries.sql, puis lancez une requête près de votre code."
- duration: 48s
- poster: 24s
- transition_in: crossfade
- status: built

## Frame 7 - Choisir l'outil

- scene: Guide de décision: pgAdmin officiel et sûr; DBeaver pour exploration/export; VS Code pour requêtes près du code.
- voiceover: "Quel outil choisir? pgAdmin est le choix officiel et sûr par défaut. DBeaver est pratique pour explorer les données et exporter. VS Code est confortable quand vos requêtes vivent à côté de votre code."
- duration: 30s
- poster: 14s
- transition_in: crossfade
- status: built

## Frame 8 - Dépannage rapide

- scene: Liste de diagnostics: service arrêté, mauvais port, mauvaise base ou utilisateur, ancien mot de passe, SSL local; commande de contrôle `psql`.
- voiceover: "Si la connexion échoue, vérifiez d'abord le service PostgreSQL, puis le port, le nom de la base, l'utilisateur, et les mots de passe enregistrés. En local, un message SSL peut apparaître: acceptez le mode simple si le cours le demande. Le test de référence reste psql avec localhost, cinq quatre trois deux, karim et pagila."
- duration: 28s
- poster: 14s
- transition_in: crossfade
- status: built

## Frame 9 - Clôture

- scene: Récapitulatif final: connexion visuelle, navigation dans les tables, première requête; prochain épisode sur les premières requêtes Pagila.
- voiceover: "Vous savez maintenant connecter pagila avec un client graphique, parcourir les tables et lancer une première requête. Au prochain épisode, nous utiliserons Pagila pour écrire nos premières vraies requêtes SQL."
- duration: 16s
- poster: 8s
- transition_in: crossfade
- status: built
