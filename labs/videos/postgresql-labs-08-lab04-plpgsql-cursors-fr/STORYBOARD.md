---
format: 1920x1080
duration: 260s
message: "Comprendre PL/pgSQL et les curseurs avant de completer le Lab 04"
arc: pourquoi -> DO block -> variables -> SELECT INTO -> boucles -> curseurs -> formes -> exceptions -> methode
audience: "debutants PostgreSQL avant lab04-intro-plpgsql-cursors"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
sources:
  - ../lab04-intro-plpgsql-cursors/README.md
  - ../lab04-intro-plpgsql-cursors/Lab-04-intro-plpgsql-cursors.sql
---

## Video direction

- Palette: meme cadre editorial que les episodes 03-07; bleu Atlantic pour concepts actifs, vert Pine pour bonnes habitudes, amber pour prudence avec les curseurs manuels et les exceptions.
- Typographie: Literata pour titres, Instrument Sans pour explications, Geist Mono pour SQL et noms de tables.
- Motion grammar: cartes mentales progressives, schema de bloc procedural, flux ligne-par-ligne, checklist finale; aucune capture reelle.
- Keepout: la bande `y=880-1080` reste libre de contenu critique.
- Niveau: introduction et roadmap du lab uniquement; ne pas remplir les blancs, ne pas donner les bonus, ne pas afficher de longs blocs solution.

## Frame 1 - Pourquoi PL/pgSQL maintenant ?

- scene: Titre de l'episode, bascule de requete SQL vers logique procedurale dans PostgreSQL.
- voiceover: "Dans les labs precedents, vous avez surtout ecrit des requetes SQL: lire, filtrer, joindre, mesurer, proteger. Avec le Lab 04, on ajoute une couche: ecrire une petite logique procedurale directement dans PostgreSQL. L'objectif n'est pas de remplacer SQL. L'objectif est de savoir quand une suite d'instructions, de variables et de tests aide a piloter un traitement."
- duration: 28s
- poster: 14s
- transition_in: cut
- status: animated
- src: index.html#frame-01

## Frame 2 - Anatomie d'un DO block

- scene: Bloc `DO $$` decoupe en `DECLARE`, `BEGIN ... END`, `RAISE NOTICE`.
- voiceover: "Le premier objet mental est le DO block. DO dit a PostgreSQL: execute ce morceau de PL/pgSQL maintenant, sans creer de fonction permanente. Le bloc commence avec le delimitateur dollar-dollar. La zone DECLARE est optionnelle et sert aux variables. La zone BEGIN, END contient les instructions. Et RAISE NOTICE devient votre premier outil de debogage."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: animated
- src: index.html#frame-02

## Frame 3 - Variables et type safety

- scene: Deux chemins de declaration: type fixe et type lie a la colonne avec `%TYPE`.
- voiceover: "Dans PL/pgSQL, une variable a un type. Vous pouvez choisir un type fixe, comme integer ou varchar. Mais le lab vous fait aussi utiliser pourcent TYPE. Quand vous declarez une variable comme customer dot email pourcent TYPE, elle suit le type de la colonne email. Si le schema evolue, le code reste plus coherent."
- duration: 28s
- poster: 14s
- transition_in: crossfade
- status: animated
- src: index.html#frame-03

## Frame 4 - SELECT INTO et conditions

- scene: Flux `SELECT ... INTO` vers variables, puis decision `IF / ELSIF / ELSE`.
- voiceover: "SELECT INTO est le pont entre une requete SQL et des variables PL/pgSQL. La requete calcule ou lit des valeurs, puis INTO les range dans les variables. Ensuite, vous pouvez tester ces valeurs avec IF, ELSIF et ELSE. Par exemple, un tarif de location peut devenir une categorie: budget, standard ou premium."
- duration: 29s
- poster: 14.5s
- transition_in: crossfade
- status: animated
- src: index.html#frame-04

## Frame 5 - Boucles: FOR, WHILE, RECORD

- scene: Progression du lab: boucle numerique, boucle sur requete, accumulation, WHILE.
- voiceover: "Le lab avance ensuite vers les boucles. Une boucle FOR sur des nombres sert a comprendre la syntaxe. Une boucle FOR sur une requete parcourt des lignes. RECORD est un conteneur flexible: il prend la forme de la ligne retournee. Vous le verrez avec category, payment et customer. Le point important est de garder un compteur, un total, ou une decision claire."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: animated
- src: index.html#frame-05

## Frame 6 - Cursors: quand et pourquoi ?

- scene: Result set transforme en file de lignes; avertissement "SQL d'abord".
- voiceover: "Un curseur est une facon de traiter un resultat ligne par ligne. Imaginez un pointeur qui avance dans un ensemble de lignes. C'est utile quand chaque ligne peut demander une action differente, quand vous gardez un etat entre les lignes, ou quand vous voulez sortir tot. Mais la regle reste simple: essayez SQL d'abord. Un SUM, un UPDATE WHERE ou un GROUP BY est souvent meilleur qu'une boucle."
- duration: 31s
- poster: 15.5s
- transition_in: crossfade
- status: animated
- src: index.html#frame-06

## Frame 7 - Trois formes de curseurs

- scene: Comparaison directe `FOR rec IN SELECT`, curseur nomme, curseur manuel.
- voiceover: "Le lab montre trois formes. La plus simple est FOR rec IN SELECT: pas de curseur a nommer, PostgreSQL gere l'iteration. Ensuite, le curseur nomme avec CURSOR FOR rend la requete reutilisable, notamment avec des parametres. Enfin, la version manuelle OPEN, FETCH, EXIT WHEN NOT FOUND, CLOSE montre le cycle complet. Elle est importante pour apprendre, mais ce n'est pas le style par defaut."
- duration: 30s
- poster: 15s
- transition_in: crossfade
- status: animated
- src: index.html#frame-07

## Frame 8 - Parametres, curseurs imbriques, exceptions

- scene: Carte d'avance: parametres, nested cursors, early exit, progress, exceptions strictes.
- voiceover: "Dans la deuxieme moitie, le lab ajoute des curseurs parametres, des curseurs imbriques, une sortie anticipee et des messages de progression. Puis il introduit SELECT INTO STRICT. Avec STRICT, PostgreSQL doit trouver exactement une ligne. Zero ligne declenche NO DATA FOUND. Plusieurs lignes declenchent TOO MANY ROWS. Ces exceptions vous obligent a penser aux cas limites."
- duration: 28s
- poster: 14s
- transition_in: crossfade
- status: animated
- src: index.html#frame-08

## Frame 9 - Methode pour reussir le lab

- scene: Checklist finale de travail: isoler, limiter, notifier, lire, documenter.
- voiceover: "Pour reussir ce lab, avancez bloc par bloc. Testez la requete SQL seule avant de l'integrer dans PL/pgSQL. Ajoutez LIMIT pendant les essais. Utilisez RAISE NOTICE pour voir les valeurs et la progression. Lisez les erreurs: il manque souvent un point-virgule, un END IF, un END LOOP ou une variable. Et gardez en commentaire ce que vous avez observe."
- duration: 26s
- poster: 13s
- transition_in: crossfade
- status: animated
- src: index.html#frame-09
