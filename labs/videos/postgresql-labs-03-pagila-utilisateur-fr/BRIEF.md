---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Préparer la base Pagila officielle et un utilisateur personnel pour les TP PostgreSQL sous Windows"
destination: youtube
aspect: 1920x1080
language: fr
audience: "débutants utilisant Windows 10 ou Windows 11 après une première connexion PostgreSQL"
length: 296s
angle: how-to
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Créer l'épisode 03/08 d'une série d'accompagnement PostgreSQL pour des étudiants débutants. La vidéo continue directement après la première connexion de l'épisode 02: l'étudiant télécharge les fichiers officiels Pagila, crée la base `pagila` avec le compte administrateur `postgres`, importe le schéma puis les données, crée son utilisateur personnel de TP, puis vérifie que l'environnement est prêt.

## Assets

- Aucun média réel requis.
- La voix finale sera fournie plus tard par l'enseignant, comme pour les épisodes 01 et 02.
- Les sous-titres français seront générés après l'alignement sur la piste WAV finale.

## Customizations

- Reproductions HTML inventées uniquement: dossier Windows, page GitHub/raw simplifiée, SQL Shell reconstruit, terminal CMD, commandes `psql`, panneaux de vérification et de dépannage.
- Continuité visuelle avec l'épisode 02: canvas chaud, titres Literata, explications Instrument Sans, commandes et chemins en Geist Mono.
- Atlantic blue pour les actions, le focus et les chemins à copier; Pine green uniquement pour les confirmations de réussite.
- Bande inférieure de 200 px réservée aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucun logo, aucune capture réelle, aucune publication automatique.

## Notes

- Source de vérité: le guide PostgreSQL Windows mis à jour, section "Loading the Pagila Sample Database".
- Source officielle à montrer:
  - `https://github.com/devrimgunduz/pagila`
  - `https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql`
  - `https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql`
- Les fichiers Pagila officiels sont importés tels que téléchargés: `pagila-schema.sql` puis `pagila-data.sql`, dans deux étapes séparées.
- Ne pas modifier les fichiers SQL officiels dans le déroulé pédagogique.
- Le compte `postgres` sert uniquement au travail de préparation et d'administration.
- L'utilisateur `karim` est seulement un exemple marocain; chaque étudiant le remplace par son propre prénom en minuscules.
- Le mot de passe du rôle personnel est privé et ne doit pas être partagé.
- Dans `psql`, les chemins d'import utilisent des slashs `/`, même sous Windows.
- Depuis CMD, enseigner la commande simple `psql -h localhost -p 5432 -U karim -d pagila`. Si `psql` n'est pas reconnu, l'étudiant revoit le PATH ou utilise SQL Shell, sans changer la commande de référence.
- Les commandes qui commencent par `\`, comme `\dt`, `\d film`, `\du`, `\c` et `\q`, sont des méta-commandes `psql`: elles pilotent la console et ne prennent pas de point-virgule.
- Si le fichier de schéma contient `OWNER TO student`, c'est un fichier modifié pour un autre cours: télécharger à nouveau le `pagila-schema.sql` officiel au lieu de l'éditer.
