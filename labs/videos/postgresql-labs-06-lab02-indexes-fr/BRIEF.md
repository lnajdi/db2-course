---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Comprendre la roadmap du Lab 02 et la methode: mesurer avant de creer des index"
destination: youtube
aspect: 1920x1080
language: fr
audience: "debutants ayant PostgreSQL, Pagila, et un client SQL pret pour executer EXPLAIN ANALYZE"
length: 250s
angle: concept
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Creer l'episode 06/08 comme introduction haut niveau au Lab 02: Indexes. L'episode prepare les etudiants a ouvrir `Lab-02-indexes.sql`, a mesurer les performances avec `EXPLAIN ANALYZE`, puis a comparer les plans avant et apres creation d'index. Il ne corrige pas le lab.

## Assets

- Aucun media reel requis.
- Source pedagogique locale: `../lab02-indexes/README.md` et `../lab02-indexes/Lab-02-indexes.sql`.
- La voix finale sera fournie plus tard par l'enseignant.
- Les sous-titres francais seront generes apres l'alignement sur la piste WAV finale.

## Customizations

- Titre visible: **Lab 02 - Indexes**, malgre le titre `Lab 03` dans le README, car le dossier et le fichier SQL identifient ce contenu comme `lab02-indexes`.
- Continuite visuelle avec les episodes 03-05: canvas chaud, titres Literata, texte Instrument Sans, code et noms SQL en Geist Mono.
- Reproductions HTML inventees uniquement: aucun logo, aucune capture reelle.
- Ne pas corriger le lab et ne pas reveler toutes les solutions; montrer seulement des extraits courts de demonstration.
- Bande inferieure de 200 px reservee aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucune publication automatique.

## Notes

- Concepts a citer: `EXPLAIN ANALYZE`, `Seq Scan`, `Index Scan`, index B-tree, index fonctionnel, index composite, `BUFFERS`, cleanup.
- Extraits SQL autorises: `CREATE INDEX idx_film_title ON film(title);`, `CREATE INDEX idx_category_upper_name ON category (UPPER(name));`, `CREATE INDEX idx_rental_date ON rental (rental_date);`, `CREATE INDEX idx_customer_last_name ON customer(last_name);`, `CREATE INDEX idx_customer_name ON customer(first_name, last_name);`, `DROP INDEX IF EXISTS ...`.
- Exemple de recherche: `film.title = 'ACADEMY DINOSAUR'`.
- Prerequis: PostgreSQL demarre, base `pagila` chargee, client SQL pret, permission de creer des index.
