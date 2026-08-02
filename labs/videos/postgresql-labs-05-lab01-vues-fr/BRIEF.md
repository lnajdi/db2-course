---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Comprendre la roadmap du Lab 01 et le principe des vues PostgreSQL"
destination: youtube
aspect: 1920x1080
language: fr
audience: "débutants ayant installé PostgreSQL, préparé Pagila, et choisi un client graphique ou psql"
length: 252s
angle: concept
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Créer l'épisode 05/08 comme introduction haut niveau au Lab 01: Views and Materialized Views. L'épisode annonce l'objectif et la roadmap du lab, puis explique le concept de vue et de vue matérialisée sans résoudre les exercices. Il prépare les étudiants à ouvrir `Lab-01-Views.sql` et à avancer section par section.

## Assets

- Aucun média réel requis.
- Source pédagogique locale: `../lab01-views/README.md` et `../lab01-views/Lab-01-Views.sql`.
- La voix finale sera fournie plus tard par l'enseignant.
- Les sous-titres français seront générés après l'alignement sur la piste WAV finale.

## Customizations

- Reproductions HTML inventées uniquement: aucun logo, aucune capture réelle.
- Continuité visuelle avec les épisodes précédents: canvas chaud, titres Literata, texte Instrument Sans, code et noms SQL en Geist Mono.
- Ne pas corriger le lab et ne pas révéler toutes les solutions; montrer seulement des extraits courts pour expliquer le modèle mental.
- Insister sur deux idées: une vue normale est une requête enregistrée, une vue matérialisée stocke physiquement un résultat qu'il faut rafraîchir.
- Bande inférieure de 200 px réservée aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucune publication automatique.

## Notes

- Concepts à citer: `CREATE VIEW`, `CREATE MATERIALIZED VIEW`, `REFRESH MATERIALIZED VIEW`, `WITH CHECK OPTION`.
- Noms de lab à montrer: `customer_info`, `film_catalog`, `public_customer_list`, `film_stats`, `solutions.sql`.
- Pré-requis: base `pagila`, utilisateur personnel comme `karim`, client GUI ou `psql`.
- Prochain épisode possible: démarrer l'exercice 1 en pratique.
