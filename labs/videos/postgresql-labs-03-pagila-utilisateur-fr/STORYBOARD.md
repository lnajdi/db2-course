---
format: 1920x1080
duration: 296.0s
message: "Préparer la base Pagila officielle et un utilisateur personnel pour les TP PostgreSQL sous Windows"
arc: how-to-process
audience: "débutants utilisant Windows 10 ou Windows 11 après une première connexion PostgreSQL"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
---

## Video direction

- Palette: canvas chaud et surfaces claires depuis `frame.md`; Atlantic blue pour les actions, focus, chemins et commandes à copier; Pine green uniquement pour les confirmations réelles; warning/danger seulement pour le dépannage final.
- Typographie: Literata pour les titres, Instrument Sans pour les explications, Geist Mono pour les chemins Windows, commandes SQL, commandes `psql`, comptes et sorties terminal.
- Motion grammar: révélations calmes et procédurales, action au moment où la voix la nomme, aucun mouvement décoratif en boucle. Les frames 03 à 05 partagent une surface SQL Shell persistante pour donner l'impression d'une seule session de préparation.
- Keepout: la bande `y=880-1080` reste libre de tout contenu critique pour les sous-titres incrustés après alignement audio.
- Invented visuals only: dossier Windows, GitHub/raw files, SQL Shell, CMD et reçus de vérification sont reconstruits en HTML; aucun logo, aucune capture réelle.

## Frame 1 - Objectif de l'épisode

- scene: Un titre annonce Pagila, puis trois objectifs se cochent: base prête, fichiers officiels importés, utilisateur personnel créé.
- voiceover: "Dans cet épisode, nous préparons l'environnement Pagila pour les TP. À la fin, vous aurez une base de données pagila prête, les fichiers officiels importés dans le bon ordre, et un utilisateur personnel pour travailler sans rester connecté comme postgres."
- duration: 24.0s
- poster: 7s
- transition_in: cut
- status: outline
- type: hook
- persuasion: Promise + checklist
- beat: orientation + sécurité
- blueprint: kinetic-type-beats (Adapt)
- focal: checklist `pagila prête`, `fichiers officiels`, `utilisateur personnel`
- roles: titre = foreground subject; checklist = foreground supporting; repère `03/08` = chrome; canvas chaud + grille légère = background
- sfx: none

narrativeRole: Donne l'objectif concret de l'épisode et explique pourquoi on prépare un compte séparé pour les TP.
keyMessage: L'étudiant terminera avec la base `pagila` et son utilisateur de travail personnel.
Scene 1 (0.0-5.0s): le kicker `03/08 · PAGILA` et le titre apparaissent à gauche par groupes de mots.
Scene 2 (5.0-17.0s): trois items de checklist arrivent un par un: `base pagila`, `schéma + données`, `utilisateur personnel`.
Scene 3 (17.0-24.0s): un mini-rail oppose `postgres = préparation` et `prénom = TP quotidien`, sans encore afficher les commandes.

## Frame 2 - Créer le dossier et télécharger les fichiers officiels

- scene: Une vue Windows stylisée montre `C:\Pagila_Project`, le dépôt officiel, les deux URLs raw et les deux fichiers SQL sauvegardés sans modification.
- voiceover: "Créez le dossier C deux-points anti-slash Pagila underscore Project. Ouvrez le dépôt officiel Pagila à l'adresse github point com slash devrimgunduz slash pagila, puis ouvrez les fichiers raw pagila-schema.sql et pagila-data.sql. Faites clic droit, enregistrer sous, gardez exactement ces deux noms de fichiers, et placez-les dans C deux-points anti-slash Pagila underscore Project. Ne modifiez pas ces fichiers: ils seront importés exactement comme ils ont été téléchargés."
- duration: 48.0s
- poster: 24s
- transition_in: crossfade
- status: outline
- type: action_setup
- persuasion: Source control + error prevention
- beat: préparation
- blueprint: cursor-ui-demo (Adapt)
- focal: dossier `C:\Pagila_Project`, liens officiels/raw, `pagila-schema.sql`, `pagila-data.sql`
- roles: explorateur Windows = foreground subject; liens raw GitHub simplifiés = supporting; fichiers exacts = focus accents; note `ne modifiez pas ces fichiers` = editorial warning
- sfx: none

narrativeRole: Ancre les fichiers nécessaires dans un dossier stable et insiste sur leur caractère officiel.
keyMessage: Les deux fichiers Pagila officiels doivent être enregistrés tels quels dans `C:\Pagila_Project`, avec leurs noms exacts.
Scene 1 (0.0-10.0s): l'explorateur Windows reconstruit crée le dossier `C:\Pagila_Project`; annotation débutant `créer ce dossier avant les imports`.
Scene 2 (10.0-26.0s): le dépôt `https://github.com/devrimgunduz/pagila` apparaît comme source officielle; un badge souligne `official/raw`.
Scene 3 (26.0-40.0s): les liens raw complets s'affichent: `https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql` et `https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql`; annotation `clic droit -> enregistrer sous`.
Scene 4 (40.0-48.0s): les fichiers `pagila-schema.sql` et `pagila-data.sql` se verrouillent en Geist Mono dans le dossier; note `gardez les noms exacts` et `ne modifiez pas ces fichiers`.

## Frame 3 - Créer la base en tant que postgres

- scene: SQL Shell connecté comme `postgres` crée la base `pagila`, puis change de base avec `\c pagila`.
- voiceover: "Ouvrez SQL Shell et connectez-vous avec l'utilisateur postgres. Ici, postgres sert au travail de préparation et d'administration. Créez la base avec CREATE DATABASE pagila, point-virgule, puis connectez-vous à cette base avec anti-slash c pagila."
- duration: 30.0s
- poster: 10s
- transition_in: push-slide LEFT
- status: outline
- type: tutorial_step
- persuasion: Admin setup + scope clarification
- beat: mise en place
- blueprint: terminal-command-sequence (Adapt)
- focal: commandes `CREATE DATABASE pagila;` et `\c pagila`
- roles: terminal SQL Shell = foreground subject; badge `postgres = administration` = foreground supporting; reçu `base courante: pagila` = success accent
- sfx: none

narrativeRole: Montre que la création de base se fait avec le compte administrateur avant de passer au travail de TP.
keyMessage: `postgres` est utilisé pour créer et préparer la base, puis la session bascule vers `pagila`.
Scene 1 (0.0-8.0s): la surface SQL Shell affiche une session `postgres=#` avec un badge `admin/setup`.
Scene 2 (8.0-18.0s): la commande se tape exactement: `CREATE DATABASE pagila;`; un reçu discret indique `CREATE DATABASE`.
Scene 3 (18.0-30.0s): la commande `\c pagila` apparaît; l'invite devient `pagila=#` avec une confirmation Pine limitée.

```sql
CREATE DATABASE pagila;
\c pagila
```

## Frame 4 - Importer le schéma officiel

- scene: SQL Shell importe uniquement `pagila-schema.sql`, avec un rail `1/2 schéma` et une annotation sur les slashs `/` dans `psql`.
- voiceover: "Importez d'abord le schéma. Dans psql, les chemins Windows s'écrivent avec des slashs, pas avec des anti-slashs. Tapez anti-slash i, espace, apostrophe, C deux-points slash Pagila underscore Project slash pagila-schema.sql, apostrophe. Cette étape crée les tables, les clés et les contraintes. Elle doit réussir avant les données."
- duration: 40.0s
- poster: 20s
- transition_in: push-slide LEFT
- status: outline
- type: tutorial_step
- persuasion: Ordered procedure + path rule
- beat: schéma d'abord
- blueprint: code-typing (Adapt)
- focal: `\i 'C:/Pagila_Project/pagila-schema.sql'`
- roles: terminal SQL Shell = foreground subject; ordre `1 schéma` = supporting rail; règle `/ dans psql` = foreground supporting; résultat `tables, clés, contraintes` = explanatory accent
- sfx: none

narrativeRole: Isole l'import du schéma pour éviter que les débutants lancent les données trop tôt.
keyMessage: Le schéma crée la structure; il doit être importé avant les données.
Scene 1 (0.0-8.0s): un rail `ordre obligatoire` met `1. schéma` en focus et grise `2. données`.
Scene 2 (8.0-20.0s): la commande s'écrit exactement dans le terminal: `\i 'C:/Pagila_Project/pagila-schema.sql'`.
Scene 3 (20.0-32.0s): des lignes de création simplifiées défilent: tables, indexes, foreign keys, constraints.
Scene 4 (32.0-40.0s): zoom calme sur `C:/Pagila_Project/...`; annotation `slashs / dans psql, même sous Windows`.

```sql
\i 'C:/Pagila_Project/pagila-schema.sql'
```

## Frame 5 - Importer les données officielles

- scene: SQL Shell importe uniquement `pagila-data.sql`, avec un rail `2/2 données` et un reçu visuel qui montre beaucoup de lignes puis le retour de `pagila=#`.
- voiceover: "Ensuite seulement, importez les données avec anti-slash i, espace, apostrophe, C deux-points slash Pagila underscore Project slash pagila-data.sql, apostrophe. Les données remplissent les tables qui existent déjà. Vous verrez beaucoup de lignes insert ou copy défiler. Attendez que l'invite pagila dièse revienne avant de continuer."
- duration: 36.0s
- poster: 18s
- transition_in: push-slide LEFT
- status: outline
- type: tutorial_step
- persuasion: Expected feedback + patience cue
- beat: données après structure
- blueprint: terminal-command-sequence (Adapt)
- focal: `\i 'C:/Pagila_Project/pagila-data.sql'` et retour de l'invite `pagila=#`
- roles: terminal SQL Shell = foreground subject; ordre `2 données` = supporting rail; lignes `INSERT/COPY` = visual feedback; invite finale `pagila=#` = success accent
- sfx: none

narrativeRole: Montre que l'import des données est long mais normal, et qu'il faut attendre le retour de l'invite.
keyMessage: Les données remplissent les tables déjà créées; continuer seulement quand `pagila=#` revient.
Scene 1 (0.0-8.0s): le rail `1 schéma terminé` puis `2 données` passe en focus.
Scene 2 (8.0-18.0s): la commande s'écrit exactement: `\i 'C:/Pagila_Project/pagila-data.sql'`.
Scene 3 (18.0-30.0s): beaucoup de lignes `INSERT 0 1`, `COPY`, `setval` défilent; une note indique `sortie longue normale`.
Scene 4 (30.0-36.0s): l'invite `pagila=#` revient; badge Pine `import terminé`.

```sql
\i 'C:/Pagila_Project/pagila-data.sql'
```

## Frame 6 - Créer son utilisateur personnel

- scene: Les commandes de rôle et de droits apparaissent par groupes, avec `karim` marqué comme exemple remplaçable et un badge mot de passe privé.
- voiceover: "Après l'import, restez connecté comme postgres et créez votre utilisateur personnel. Karim est seulement un exemple: chaque étudiant remplace karim par son propre prénom en minuscules. Choisissez un mot de passe privé et ne le partagez pas. Ensuite, accordez les droits sur la base pagila, le schéma public, les tables et les séquences."
- duration: 42.0s
- poster: 14s
- transition_in: push-slide LEFT
- status: outline
- type: tutorial_step
- persuasion: Least privilege + personalization
- beat: autonomie encadrée
- blueprint: annotated-code-block (Adapt)
- focal: `CREATE ROLE karim...` et les quatre `GRANT`
- roles: terminal SQL Shell = foreground subject; substitution `karim -> votre prénom en minuscules` = foreground supporting; confidentialité mot de passe = warning note
- sfx: none

narrativeRole: Sépare le compte d'administration du compte de travail quotidien et donne les droits nécessaires.
keyMessage: `karim` est un exemple; chaque étudiant crée son rôle personnel avec un mot de passe privé.
Scene 1 (0.0-9.0s): le terminal reste sur `pagila=#`; un badge rappelle `connecté comme postgres`.
Scene 2 (9.0-19.0s): `CREATE ROLE karim...` apparaît; `karim` reçoit une étiquette `exemple`.
Scene 3 (19.0-34.0s): les `GRANT` se groupent en quatre blocs: base, schéma, tables, séquences.
Scene 4 (34.0-42.0s): un panneau de remplacement montre `karim -> votre prénom en minuscules`; une note indique `mot de passe privé`.

```sql
CREATE ROLE karim WITH LOGIN PASSWORD 'votre_mot_de_passe';
GRANT ALL PRIVILEGES ON DATABASE pagila TO karim;
GRANT ALL ON SCHEMA public TO karim;
GRANT ALL ON ALL TABLES IN SCHEMA public TO karim;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO karim;
```

## Frame 7 - Se connecter comme utilisateur de TP

- scene: Un terminal CMD lance `psql -h localhost -p 5432 -U karim -d pagila`, annote chaque flag, puis affiche une connexion réussie.
- voiceover: "Pour vérifier le compte de TP, ouvrez un terminal CMD et lancez psql tiret h localhost tiret p cinq quatre trois deux tiret U karim tiret d pagila. Tiret h indique l'hôte, tiret p le port, tiret U l'utilisateur, et tiret d la base de données. Si psql n'est pas reconnu, revoyez le PATH ou utilisez SQL Shell; la commande à comprendre reste psql suivi de ces paramètres."
- duration: 32.0s
- poster: 16s
- transition_in: crossfade
- status: outline
- type: verification_step
- persuasion: Role switch + direct check
- beat: passage au compte de TP
- blueprint: terminal-command-sequence (Adapt)
- focal: `psql -h localhost -p 5432 -U karim -d pagila`
- roles: terminal CMD = foreground subject; paramètres hôte/port/user/base = supporting annotations; note PATH/SQL Shell = beginner fallback; confirmation `pagila=>` = success accent
- sfx: none

narrativeRole: Confirme que l'utilisateur personnel peut se connecter directement à la base de TP.
keyMessage: La connexion de travail utilise le rôle personnel, pas `postgres`.
Scene 1 (0.0-8.0s): le terminal CMD remplace SQL Shell; la commande simple `psql -h localhost -p 5432 -U karim -d pagila` est encadrée.
Scene 2 (8.0-22.0s): les paramètres s'annotent: `-h` = hôte, `-p` = port, `-U` = utilisateur, `-d` = base.
Scene 3 (22.0-28.0s): une note débutant affiche `psql non reconnu ? revoir PATH ou utiliser SQL Shell`.
Scene 4 (28.0-32.0s): une invite `pagila=>` apparaît avec un badge Pine `connecté comme utilisateur de TP`.

```cmd
psql -h localhost -p 5432 -U karim -d pagila
```

## Frame 8 - Comprendre les méta-commandes psql

- scene: Une carte distingue SQL et méta-commandes `psql`, puis explique `\dt`, `\d film`, `\du`, `\c` et `\q`.
- voiceover: "Avant la dernière vérification, retenez ceci: les commandes qui commencent par anti-slash sont des méta-commandes de psql. Elles ne sont pas du SQL et elles ne prennent pas de point-virgule. Anti-slash d t liste les tables, anti-slash d suivi d'un nom décrit un objet, anti-slash d u liste les utilisateurs, anti-slash c change de base, et anti-slash q quitte la console."
- duration: 24.0s
- poster: 8s
- transition_in: crossfade
- status: outline
- type: concept_explain
- persuasion: Definition + contrast
- beat: repère de lecture
- blueprint: annotated-diagram (Adapt)
- focal: `\dt`, `\d film`, `\du`, `\c pagila`, `\q`
- roles: terminal `pagila=>` = foreground subject; carte `SQL` vs `psql` = foreground supporting; exemples de méta-commandes = command rail
- sfx: none

narrativeRole: Explique les commandes `psql` qui commencent par anti-slash avant de les utiliser pour vérifier Pagila.
keyMessage: Les méta-commandes `psql` pilotent la console; elles ne sont pas du SQL et ne prennent pas de point-virgule.
Scene 1 (0.0-6.0s): deux colonnes apparaissent: `SQL` avec `SELECT ...;` et `psql` avec `\dt`.
Scene 2 (6.0-17.0s): cinq commandes se révèlent comme une mini-fiche: `\dt` liste les tables, `\d film` décrit une table, `\du` liste les rôles, `\c pagila` change de base, `\q` quitte.
Scene 3 (17.0-24.0s): la règle finale se verrouille: `anti-slash = commande psql`, `pas de point-virgule`.

```sql
\dt
\d film
\du
\c pagila
\q
```

## Frame 9 - Vérifier et dépanner

- scene: `\dt` liste les tables, `SELECT COUNT(*) FROM film;` confirme le chargement, puis un panneau explique le cas `OWNER TO student`.
- voiceover: "Une fois connecté à pagila, tapez anti-slash d t pour lister les tables, puis SELECT COUNT étoile FROM film, point-virgule. Si le schéma mentionne OWNER TO student, vous n'avez pas le fichier officiel: téléchargez à nouveau pagila-schema.sql depuis Pagila, au lieu de modifier le fichier."
- duration: 20.0s
- poster: 8s
- transition_in: crossfade
- status: outline
- type: troubleshooting
- persuasion: Verification + corrective path
- beat: confiance finale
- blueprint: grid-card-assemble (Adapt)
- focal: `\dt`, `SELECT COUNT(*) FROM film;`, diagnostic `OWNER TO student`
- roles: terminal `pagila=>` = foreground subject; cartes vérification = foreground supporting; panneau dépannage = warning accent
- sfx: none

narrativeRole: Donne deux vérifications rapides et un dépannage important sans encourager la modification des fichiers officiels.
keyMessage: Si les tables et `film` répondent, Pagila est prête; un `OWNER TO student` indique un mauvais fichier à retélécharger.
Scene 1 (0.0-6.0s): `\dt` se tape et une table simplifiée liste `actor`, `film`, `customer`, `rental`.
Scene 2 (6.0-12.0s): `SELECT COUNT(*) FROM film;` renvoie une valeur attendue autour de `1000`.
Scene 3 (12.0-20.0s): un panneau `OWNER TO student ?` indique `fichier modifié -> retélécharger l'officiel`, avec une confirmation finale `Pagila prête pour les TP`.

```sql
\dt
SELECT COUNT(*) FROM film;
```
