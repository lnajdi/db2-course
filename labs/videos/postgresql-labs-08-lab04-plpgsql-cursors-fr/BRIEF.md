---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Introduire PL/pgSQL et les curseurs avant le Lab 04"
destination: youtube
aspect: 1920x1080
language: fr
audience: "debutants PostgreSQL avant lab04-intro-plpgsql-cursors"
length: 260s
angle: concept-roadmap
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Creer l'episode 08/08 comme introduction conceptuelle au lab `lab04-intro-plpgsql-cursors`. L'episode doit preparer les etudiants a lire et completer le fichier SQL: PL/pgSQL, blocs `DO $$`, variables, `%TYPE`, `SELECT INTO`, structures de controle, boucles, curseurs, exceptions et `RAISE NOTICE`.

## Assets

- Aucun media reel requis.
- Sources pedagogiques locales:
  - `../lab04-intro-plpgsql-cursors/README.md`
  - `../lab04-intro-plpgsql-cursors/Lab-04-intro-plpgsql-cursors.sql`
- La voix finale sera fournie plus tard par l'enseignant.
- Les sous-titres francais seront generes apres alignement sur la piste WAV finale.

## Customizations

- Titre visible: **Lab 04 - PL/pgSQL et curseurs**.
- Positionnement: concept et roadmap, pas correction.
- Continuite visuelle avec les episodes 03-07: canvas chaud, titres Literata, texte Instrument Sans, SQL en Geist Mono.
- Montrer seulement des ancres SQL courtes: `DO $$`, `DECLARE`, `BEGIN ... END`, `RAISE NOTICE`, `SELECT ... INTO`, `FOR rec IN SELECT`, `CURSOR FOR`, `OPEN / FETCH / CLOSE`, `EXCEPTION`.
- Ne pas remplir les blancs du lab, ne pas afficher les solutions bonus, ni les longs blocs de reporting business.
- Bande inferieure de 200 px reservee aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucune publication automatique.

## Notes

- Le README et le SQL contiennent encore un libelle interne "Lab 03"; utiliser le numero visible **Lab 04**, car le dossier et le fichier source cible identifient ce lab comme Lab 04.
- Noms SQL visibles a conserver: `customer`, `rental`, `payment`, `film`, `category`, `store`, `address`, `city`, `country`.
- Regle pedagogique a marteler: essayer le SQL ensembliste d'abord; utiliser un curseur quand il faut de l'etat ou une branche par ligne.
