---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Utiliser SQL Shell (psql) sous Windows pour effectuer une première connexion locale à PostgreSQL"
destination: youtube
aspect: 1920x1080
language: fr
audience: "débutants utilisant Windows 10 ou Windows 11 après l'installation de PostgreSQL"
length: 190s
angle: how-to
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Créer l'épisode 02/08 d'une série d'accompagnement PostgreSQL pour des étudiants débutants. La vidéo continue directement après l'installation de l'épisode 01: l'étudiant ouvre SQL Shell (psql), accepte les valeurs locales proposées, saisit le mot de passe créé pendant l'installation, reconnaît l'invite `postgres=#`, exécute quelques commandes de vérification, puis quitte proprement.

## Assets

- Aucun média réel requis.
- La voix finale sera fournie plus tard par l'enseignant, comme pour l'épisode 01.
- Les sous-titres français seront générés après l'alignement sur la piste WAV finale.

## Customizations

- Reproductions HTML inventées uniquement: menu Démarrer Windows stylisé, terminal SQL Shell reconstruit, prompts psql, panneaux d'aide.
- Continuité visuelle avec l'épisode 01: canvas chaud, titres Literata, explications Instrument Sans, commandes et prompts en Geist Mono.
- Atlantic blue pour les actions et focus; Pine green uniquement pour la connexion réussie et la clôture.
- Bande inférieure de 200 px réservée aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucun logo, aucune capture réelle, aucune publication automatique.

## Notes

- Valeurs de connexion locales: `localhost`, base `postgres`, port `5432`, utilisateur `postgres`.
- Le mot de passe n'est jamais affiché pendant la saisie dans SQL Shell.
- L'invite de réussite attendue est `postgres=#`: `postgres` indique la base courante, `#` indique une session superutilisateur.
- Les premières commandes sont des vérifications: `SELECT version();`, `\conninfo`, `\l`.
- La commande de sortie est `\q`.
- Les erreurs fréquentes à couvrir: mot de passe incorrect, service PostgreSQL arrêté, port différent de `5432`, commande `psql` absente dans un terminal ordinaire à cause du PATH.
- Le rendu final attend la piste WAV de l'enseignant.
