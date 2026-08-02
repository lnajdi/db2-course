---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Connecter Pagila avec pgAdmin, DBeaver Community et PostgreSQL for Visual Studio Code"
destination: youtube
aspect: 1920x1080
language: fr
audience: "débutants Windows ayant déjà installé PostgreSQL, créé Pagila et un utilisateur personnel"
length: 300s
angle: how-to
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Créer l'épisode 04/08 d'une série d'accompagnement PostgreSQL pour des étudiants débutants. La vidéo continue après la préparation de `pagila`: elle rappelle que `psql` a déjà été utilisé dans les épisodes précédents comme client en console, puis montre que pgAdmin, DBeaver Community et VS Code sont simplement des clients graphiques GUI connectés au même serveur local, avec les mêmes paramètres, le même utilisateur de travail, et une première requête simple.

## Assets

- Aucun média réel requis.
- La voix finale sera fournie plus tard par l'enseignant.
- Les sous-titres français seront générés après l'alignement sur la piste WAV finale.

## Customizations

- Reproductions HTML inventées uniquement: aucune capture réelle, aucun logo officiel, aucune interface propriétaire capturée.
- Continuité visuelle avec les épisodes précédents: canvas chaud, titres Literata, texte Instrument Sans, code et paramètres en Geist Mono.
- Tous les clients utilisent `localhost`, `5432`, `pagila`, `karim`, avec rappel que `karim` doit être remplacé par le prénom personnel en minuscules.
- Pour les débutants, insister sur l'idée suffisante: un client GUI est une interface graphique pour envoyer des requêtes au serveur PostgreSQL; il ne remplace pas le serveur.
- Le compte `postgres` reste réservé à l'administration; le travail quotidien dans les clients graphiques utilise le compte personnel.
- Bande inférieure de 200 px réservée aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucune publication automatique.

## Notes

- Sources de référence:
  - pgAdmin Windows: `https://www.pgadmin.org/download/pgadmin-4-windows/`
  - DBeaver Community: `https://dbeaver.io/download/`
  - VS Code Marketplace: `https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-pgsql`
  - Microsoft Learn: `https://learn.microsoft.com/en-us/azure/postgresql/development/vs-code-extension/postgresql-extension-overview`
- Nom correct de l'extension VS Code actuelle: **PostgreSQL for Visual Studio Code**.
- Identifiant correct de l'extension: `ms-ossdata.vscode-pgsql`.
- Episode centré sur la connexion et la première requête, pas sur une installation complète de chaque outil.
