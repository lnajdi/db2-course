---
format: 1920x1080
duration: 260s
message: "Avant le lab securite, confirmer le modele mental: identites, droits, schemas, lignes et verification"
arc: pourquoi -> user role -> privileges -> least privilege -> schemas -> tables sequences -> rls -> verifier
audience: "debutants PostgreSQL avant lab03-PostgreSQL-Security-UserManagement"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
sources:
  - ../lab03-PostgreSQL-Security-UserManagement/README.md
  - ../lab03-PostgreSQL-Security-UserManagement/lab03-PostgreSQL-Security-UserManagement.sql
---

## Video direction

- Palette: meme cadre editorial que les episodes 03-06; bleu Atlantic pour concepts actifs, vert Pine pour confirmations, warning pour erreurs de permission, rouge discret pour refus d'acces.
- Typographie: Literata pour titres, Instrument Sans pour explications, Geist Mono pour SQL, roles, schemas, tables et erreurs.
- Motion grammar: cartes mentales progressives, hierarchies de privileges, frontieres de schema, filtres de lignes inventes, aucune capture reelle.
- Keepout: la bande `y=880-1080` reste libre de contenu critique.
- Niveau: rappel de concepts uniquement, pas correction complete du lab et pas exposition de mots de passe.

## Frame 1 - Pourquoi ce rappel ?

- scene: Titre de l'episode, trois questions mentales: qui se connecte, quoi est autorise, ou sont les objets.
- voiceover: "Avant de commencer le lab securite et gestion des utilisateurs, faisons un rappel. L'objectif n'est pas de corriger les exercices. L'objectif est de verifier le modele mental: qui se connecte a PostgreSQL, ce que cette identite a le droit de faire, et dans quel schema les objets sont ranges."
- duration: 30s
- poster: 15s
- transition_in: cut
- status: animated
- src: index.html#frame-01

## Frame 2 - User vs role

- scene: Deux colonnes: roles qui portent des droits, users qui peuvent se connecter. Exemples `app_user`, `analyst_user`, `view_reader`, `analyst_role`.
- voiceover: "Dans PostgreSQL, le mot important est role. Un role est une identite de base de donnees: il peut recevoir des droits et posseder des objets. Un user est simplement un role qui a le droit de se connecter. Dans le lab, app_user et analyst_user sont des utilisateurs. view_reader et analyst_role sont plutot des roles de droits reutilisables."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: animated
- src: index.html#frame-02

## Frame 3 - Privileges: autorisations explicites

- scene: Une pile database -> schema -> object, avec droits courts `CONNECT`, `USAGE`, `SELECT`, `INSERT`, `CREATE`.
- voiceover: "Un privilege est une autorisation explicite. CONNECT permet d'entrer dans la base. USAGE permet d'utiliser un schema. SELECT lit une table ou une vue. INSERT ajoute des lignes. CREATE permet de creer des objets dans un espace donne. Si le droit manque, PostgreSQL refuse. Ce refus est normal: c'est le systeme de securite qui travaille."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: animated
- src: index.html#frame-03

## Frame 4 - Least privilege

- scene: Comparaison entre superuser partout et utilisateur limite; le chemin limite est coche.
- voiceover: "La regle centrale est le principe du moindre privilege. On ne donne pas tous les droits par confort. Une application n'a pas besoin d'etre superuser. Un lecteur de vues n'a pas besoin de modifier les tables. Un analyste peut avoir de la lecture large sans recevoir le pouvoir de detruire les objets. Chaque droit doit correspondre a un vrai besoin."
- duration: 32s
- poster: 16s
- transition_in: crossfade
- status: animated
- src: index.html#frame-04

## Frame 5 - Schemas: dossiers logiques et frontieres

- scene: Deux zones `public` et `app_data`, avec la distinction `USAGE` != `CREATE`.
- voiceover: "Un schema est un dossier logique dans une base PostgreSQL. Il evite les conflits de noms et il sert aussi de frontiere de securite. Dans le lab, app_data separe les objets de l'application du schema public. Attention: avoir USAGE sur un schema permet de le traverser pour atteindre des objets autorises. Ce n'est pas la meme chose que CREATE, qui permet d'y creer de nouveaux objets."
- duration: 36s
- poster: 18s
- transition_in: crossfade
- status: animated
- src: index.html#frame-05

## Frame 6 - Tables et sequences

- scene: Insertion dans `tasks` avec fleche vers sequence; la table et la sequence ont chacune leur verrou de privilege.
- voiceover: "Les droits ne s'arretent pas a la table. Quand une colonne utilise SERIAL, PostgreSQL s'appuie sur une sequence pour produire la prochaine valeur. Donc un utilisateur peut avoir INSERT sur une table, puis echouer parce qu'il n'a pas USAGE sur la sequence associee. C'est une erreur tres utile: elle montre que table et sequence sont deux objets differents."
- duration: 32s
- poster: 16s
- transition_in: crossfade
- status: animated
- src: index.html#frame-06

## Frame 7 - Row-Level Security

- scene: Table `tasks` filtree par utilisateur courant; privileges de table en haut, filtre de lignes en bas.
- voiceover: "Row-Level Security ajoute une couche plus fine. Les privileges normaux repondent a la question: ai-je le droit d'utiliser cette table? RLS repond ensuite: quelles lignes ai-je le droit de voir ou de modifier? Le modele du lab est simple: dans app_data.tasks, chaque utilisateur ne voit que les lignes ou assigned_to correspond a current_user."
- duration: 34s
- poster: 17s
- transition_in: crossfade
- status: animated
- src: index.html#frame-07

## Frame 8 - Verifier sa comprehension dans le lab

- scene: Checklist de verification: se connecter comme le bon user, lire les erreurs, interroger catalogues, nettoyer a la fin.
- voiceover: "Pendant le lab, ne verifiez pas seulement comme postgres. Testez avec le vrai utilisateur limite: app_user ou analyst_user. Lisez les erreurs de permission, elles indiquent souvent le niveau manquant: base, schema, table ou sequence. Utilisez les requetes de verification sur pg_roles, pg_auth_members, information_schema et pg_policies. Et gardez le nettoyage pour la fin, quand vous avez compris ce que chaque droit change."
- duration: 28s
- poster: 14s
- transition_in: crossfade
- status: animated
- src: index.html#frame-08
