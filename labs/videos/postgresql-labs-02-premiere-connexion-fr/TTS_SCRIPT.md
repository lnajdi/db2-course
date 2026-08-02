# TTS Script - Première connexion PostgreSQL

## Simple Prompt

Génère une narration française, scène par scène, pour une vidéo pédagogique sur la première connexion à PostgreSQL avec SQL Shell sous Windows. Garde un rythme naturel, clair et rassurant. Respecte strictement le budget de durée de chaque scène. Lis les commandes exactement, conserve les cues inline comme `[short pause]` et `[emphasis]`, et termine chaque scène avec la pause indiquée.

## Timed Production Script

[Scene 01 | 00:00-00:22 | friendly | natural pace]
Narration: Dans cet épisode, nous allons faire la première connexion locale à PostgreSQL avec SQL Shell. [short pause] À la fin, vous saurez ouvrir l'outil, répondre aux prompts, reconnaître l'invite `postgres=#`, lancer une première vérification, puis sortir proprement.
Pronunciation: PostgreSQL = post-gresse-Q-L; SQL Shell = ess-ku-elle shell; postgres = post-gresse.
End pause: 0.5 seconds

[Scene 02 | 00:22-00:46 | friendly | natural pace]
Narration: Ouvrez le menu Démarrer de Windows et cherchez SQL Shell, entre parenthèses psql. [short pause] Utilisez cette entrée pour commencer. Elle lance le client installé avec PostgreSQL et évite les problèmes de PATH dans un terminal ordinaire.
Pronunciation: SQL Shell = ess-ku-elle shell; psql = pi-ess-ku-elle; PATH = path.
End pause: 0.5 seconds

[Scene 03 | 00:46-01:18 | friendly | slower on prompts]
Narration: SQL Shell pose ensuite quelques questions. Pour une installation locale standard, appuyez sur Entrée pour accepter `localhost`, puis `postgres`, puis `5432`, puis encore `postgres`. [short pause] Quand le mot de passe est demandé, tapez celui que vous avez créé pendant l'installation. Il ne s'affiche pas pendant la saisie: c'est normal.
Pronunciation: localhost = local host; postgres = post-gresse; 5432 = cinq quatre trois deux.
End pause: 0.5 seconds

[Scene 04 | 01:18-01:42 | friendly | confident]
Narration: Si la connexion réussit, vous voyez l'invite `postgres=#`. [short pause] Le mot `postgres` indique la base de données courante. Le symbole dièse indique ici une session superutilisateur. À partir de cette invite, SQL Shell attend vos commandes.
Pronunciation: postgres = post-gresse; dièse = dire le symbole # comme dièse.
End pause: 0.5 seconds

[Scene 05 | 01:42-02:20 | friendly | command reading]
Narration: Pour vérifier que tout répond, tapez `SELECT version();` puis Entrée. [short pause] La commande affiche la version du serveur PostgreSQL. Tapez ensuite `\conninfo` pour voir à quelle base, avec quel utilisateur et sur quel port vous êtes connecté. Enfin, `\l` affiche la liste des bases. Ici, l'objectif est seulement de vérifier la connexion, pas encore d'apprendre SQL.
Pronunciation: SELECT version = sélecte version; conninfo = conn info; \l = anti-slash elle; SQL = ess-ku-elle.
End pause: 0.5 seconds

[Scene 06 | 02:20-02:48 | friendly | concise troubleshooting]
Narration: Pour quitter SQL Shell, tapez `\q` puis Entrée. [short pause] Si la connexion échoue, vérifiez d'abord le mot de passe. Si le serveur ne répond pas, vérifiez que le service PostgreSQL est démarré. Si vous avez changé le port pendant l'installation, indiquez ce port. Et si `psql` n'est pas reconnu dans un terminal ordinaire, ce n'est pas bloquant: utilisez SQL Shell.
Pronunciation: \q = anti-slash q; PostgreSQL = post-gresse-Q-L; psql = pi-ess-ku-elle.
End pause: 0.5 seconds

[Scene 07 | 02:48-03:10 | friendly | closing]
Narration: Vous avez maintenant validé la première connexion locale. [short pause] Vous savez ouvrir SQL Shell, accepter les valeurs par défaut, reconnaître l'invite de réussite, lancer des vérifications simples et quitter. Dans l'épisode suivant, nous préparerons la base et l'utilisateur de travail pour les TP.
Pronunciation: SQL Shell = ess-ku-elle shell; TP = té-pé.
End pause: 0.5 seconds

## Clean TTS-Ready Script

Dans cet épisode, nous allons faire la première connexion locale à PostgreSQL avec SQL Shell. [short pause] À la fin, vous saurez ouvrir l'outil, répondre aux prompts, reconnaître l'invite `postgres=#`, lancer une première vérification, puis sortir proprement.

Ouvrez le menu Démarrer de Windows et cherchez SQL Shell, entre parenthèses psql. [short pause] Utilisez cette entrée pour commencer. Elle lance le client installé avec PostgreSQL et évite les problèmes de PATH dans un terminal ordinaire.

SQL Shell pose ensuite quelques questions. Pour une installation locale standard, appuyez sur Entrée pour accepter `localhost`, puis `postgres`, puis `5432`, puis encore `postgres`. [short pause] Quand le mot de passe est demandé, tapez celui que vous avez créé pendant l'installation. Il ne s'affiche pas pendant la saisie: c'est normal.

Si la connexion réussit, vous voyez l'invite `postgres=#`. [short pause] Le mot `postgres` indique la base de données courante. Le symbole dièse indique ici une session superutilisateur. À partir de cette invite, SQL Shell attend vos commandes.

Pour vérifier que tout répond, tapez `SELECT version();` puis Entrée. [short pause] La commande affiche la version du serveur PostgreSQL. Tapez ensuite `\conninfo` pour voir à quelle base, avec quel utilisateur et sur quel port vous êtes connecté. Enfin, `\l` affiche la liste des bases. Ici, l'objectif est seulement de vérifier la connexion, pas encore d'apprendre SQL.

Pour quitter SQL Shell, tapez `\q` puis Entrée. [short pause] Si la connexion échoue, vérifiez d'abord le mot de passe. Si le serveur ne répond pas, vérifiez que le service PostgreSQL est démarré. Si vous avez changé le port pendant l'installation, indiquez ce port. Et si `psql` n'est pas reconnu dans un terminal ordinaire, ce n'est pas bloquant: utilisez SQL Shell.

Vous avez maintenant validé la première connexion locale. [short pause] Vous savez ouvrir SQL Shell, accepter les valeurs par défaut, reconnaître l'invite de réussite, lancer des vérifications simples et quitter. Dans l'épisode suivant, nous préparerons la base et l'utilisateur de travail pour les TP.

## Pronunciation Glossary

- PostgreSQL: post-gresse-Q-L
- postgres: post-gresse
- SQL Shell: ess-ku-elle shell
- psql: pi-ess-ku-elle
- SQL: ess-ku-elle
- localhost: local host
- PATH: path
- `5432`: cinq quatre trois deux
- `SELECT version();`: sélecte version
- `\conninfo`: anti-slash conn info
- `\l`: anti-slash elle
- `\q`: anti-slash q
