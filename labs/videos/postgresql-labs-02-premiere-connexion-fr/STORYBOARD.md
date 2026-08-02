---
format: 1920x1080
duration: 190.0s
message: "Utiliser SQL Shell (psql) sous Windows pour effectuer une première connexion locale à PostgreSQL"
arc: how-to-process
audience: "débutants utilisant Windows 10 ou Windows 11 après l'installation de PostgreSQL"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880-1080"
audio_status: waiting_for_external_final_wav
---

## Video direction

- Palette: canvas chaud et surfaces claires depuis `frame.md`; Atlantic blue pour les actions, focus et transitions; Pine green uniquement pour les confirmations réelles; warning/danger seulement pour le dépannage.
- Typographie: Literata pour les titres, Instrument Sans pour les explications, Geist Mono pour les prompts, commandes, ports, comptes et sorties terminal.
- Motion grammar: révélations calmes, action au moment où la voix la nomme, aucun mouvement décoratif en boucle. Les frames 03 à 06 partagent une surface terminal persistante pour donner l'impression d'une seule session.
- Keepout: la bande `y=880-1080` reste libre de tout contenu critique pour les sous-titres incrustés après alignement audio.
- Invented visuals only: menu Démarrer, SQL Shell, terminal et reçus sont reconstruits en HTML; aucun logo, aucune capture réelle.

## Frame 1 - Objectif de l'épisode

- scene: Le titre annonce la première connexion et une checklist de cinq résultats se construit à droite.
- voiceover: "Dans cet épisode, nous allons faire la première connexion locale à PostgreSQL avec SQL Shell. À la fin, vous saurez ouvrir l'outil, répondre aux prompts, reconnaître l'invite postgres égal dièse, lancer une première vérification, puis sortir proprement."
- duration: 22.0s
- poster: 6s
- transition_in: cut
- status: animated
- src: compositions/frames/01-objectif-episode.html
- type: hook
- persuasion: Promise + checklist
- beat: orientation + confiance
- blueprint: kinetic-type-beats (Adapt)
- focal: checklist ouvrir, connecter, reconnaître, vérifier, quitter
- roles: titre = foreground subject; checklist = foreground supporting; canvas chaud + grille légère = background
- sfx: none

narrativeRole: Donne l'objectif concret de l'épisode et réduit l'anxiété avant le terminal.
keyMessage: La première connexion se limite à ouvrir SQL Shell, accepter les valeurs locales, vérifier, puis quitter.
Scene 1 (0.0-5.0s): le kicker `02/08 · CONNEXION` et le titre apparaissent à gauche par groupes de mots.
Scene 2 (5.0-16.0s): les cinq items de la checklist arrivent un par un au rythme de la voix.
Scene 3 (16.0-22.0s): la ligne `postgres=#` se pose en mono comme repère final, sans Pine avant la réussite réelle.

## Frame 2 - Ouvrir SQL Shell

- scene: Un menu Démarrer stylisé filtre la recherche puis isole `SQL Shell (psql)`.
- voiceover: "Ouvrez le menu Démarrer de Windows et cherchez SQL Shell, entre parenthèses psql. Utilisez cette entrée pour commencer. Elle lance le client installé avec PostgreSQL et évite les problèmes de PATH dans un terminal ordinaire."
- duration: 24.0s
- poster: 8s
- transition_in: crossfade
- status: animated
- src: compositions/frames/02-ouvrir-sql-shell.html
- type: action_setup
- persuasion: Demonstration + risk reduction
- beat: action claire
- blueprint: cursor-ui-demo (Adapt)
- focal: entrée `SQL Shell (psql)` dans le menu Démarrer
- roles: menu Démarrer = foreground subject; recherche = supporting; note PATH = foreground supporting
- sfx: none

narrativeRole: Montre le chemin Windows le moins fragile pour ouvrir psql.
keyMessage: SQL Shell lance directement le client installé, même si `psql` n'est pas dans le PATH.
Scene 1 (0.0-6.0s): le menu Démarrer reconstruit s'ouvre avec un champ de recherche vide.
Scene 2 (6.0-13.0s): la recherche `SQL Shell` se tape et l'entrée `SQL Shell (psql)` devient le résultat principal.
Scene 3 (13.0-24.0s): un rail explique `PATH non requis` pendant que l'entrée reste encadrée en Atlantic blue.

## Frame 3 - Répondre aux prompts

- scene: Le terminal SQL Shell affiche les quatre prompts et montre les touches Entrée puis le mot de passe masqué.
- voiceover: "SQL Shell pose ensuite quelques questions. Pour une installation locale standard, appuyez sur Entrée pour accepter localhost, puis postgres, puis 5432, puis encore postgres. Quand le mot de passe est demandé, tapez celui que vous avez créé pendant l'installation. Il ne s'affiche pas pendant la saisie: c'est normal."
- duration: 32.0s
- poster: 12s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/03-repondre-prompts.html
- type: tutorial_step
- persuasion: Progressive disclosure + default anchoring
- beat: maîtrise
- blueprint: code-typing (Adapt)
- focal: prompts `Server`, `Database`, `Port`, `Username`, `Password`
- roles: terminal = foreground subject; rail valeurs par défaut = foreground supporting; touches Entrée = supporting actor
- sfx: none

narrativeRole: Transforme une suite de prompts intimidante en routine de valeurs par défaut.
keyMessage: Pour une installation locale standard, valider les valeurs entre crochets suffit; le mot de passe reste invisible.
Scene 1 (0.0-6.0s): la fenêtre `SQL Shell (psql)` s'établit, vide.
Scene 2 (6.0-20.0s): les prompts `Server [localhost]`, `Database [postgres]`, `Port [5432]`, `Username [postgres]` apparaissent un par un; une touche Entrée se synchronise à chaque valeur.
Scene 3 (20.0-32.0s): le prompt de mot de passe apparaît; la saisie est représentée par une ligne vide et une note `saisie masquée`.

## Frame 4 - Reconnaître une connexion réussie

- scene: Le terminal affiche `postgres=#` et un panneau décortique `postgres` puis `#`.
- voiceover: "Si la connexion réussit, vous voyez l'invite postgres égal dièse. Le mot postgres indique la base de données courante. Le symbole dièse indique ici une session superutilisateur. À partir de cette invite, SQL Shell attend vos commandes."
- duration: 24.0s
- poster: 8s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/04-connexion-reussie.html
- type: concept_explain
- persuasion: Definition + visual parsing
- beat: soulagement
- blueprint: annotated-diagram (Adapt)
- focal: invite `postgres=#`
- roles: terminal = foreground subject; annotations = foreground supporting; confirmation Pine = success accent
- sfx: none

narrativeRole: Donne un critère de réussite immédiatement observable.
keyMessage: `postgres=#` signifie que la session locale est ouverte et prête à recevoir des commandes.
Scene 1 (0.0-5.0s): l'invite `postgres=#` apparaît en Pine dans le terminal.
Scene 2 (5.0-15.0s): deux annotations relient `postgres` à `base courante` et `#` à `superutilisateur`.
Scene 3 (15.0-24.0s): le curseur clignote sobrement après l'invite, prêt pour la suite.

## Frame 5 - Lancer les premières commandes

- scene: Trois commandes de vérification sont tapées, chacune avec un reçu court.
- voiceover: "Pour vérifier que tout répond, tapez SELECT version, parenthèse ouvrante, parenthèse fermante, point-virgule, puis Entrée. La commande affiche la version du serveur PostgreSQL. Tapez ensuite anti-slash conninfo pour voir à quelle base, avec quel utilisateur et sur quel port vous êtes connecté. Enfin, anti-slash elle affiche la liste des bases. Ici, l'objectif est seulement de vérifier la connexion, pas encore d'apprendre SQL."
- duration: 38.0s
- poster: 14s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/05-premieres-commandes.html
- type: feature_showcase
- persuasion: Verification sequence
- beat: compétence
- blueprint: terminal-command-sequence (Adapt)
- focal: `SELECT version();`, `\conninfo`, `\l`
- roles: terminal = foreground subject; reçu de vérification = foreground supporting; avertissement pédagogie = editorial note
- sfx: none

narrativeRole: Montre trois commandes utiles sans ouvrir un cours SQL complet.
keyMessage: Ces commandes vérifient le serveur, la connexion active et la liste des bases.
Scene 1 (0.0-10.0s): `SELECT version();` est tapé, puis un résultat court `PostgreSQL server répond`.
Scene 2 (10.0-23.0s): `\conninfo` apparaît avec un reçu `base postgres · user postgres · port 5432`.
Scene 3 (23.0-32.0s): `\l` affiche une table simplifiée des bases.
Scene 4 (32.0-38.0s): une note rappelle `vérification seulement`, sans surcharge SQL.

## Frame 6 - Sortir et corriger les erreurs fréquentes

- scene: La commande `\q` quitte SQL Shell, puis quatre erreurs fréquentes sont rangées dans un panneau de dépannage.
- voiceover: "Pour quitter SQL Shell, tapez anti-slash q puis Entrée. Si la connexion échoue, vérifiez d'abord le mot de passe. Si le serveur ne répond pas, vérifiez que le service PostgreSQL est démarré. Si vous avez changé le port pendant l'installation, indiquez ce port. Et si psql n'est pas reconnu dans un terminal ordinaire, ce n'est pas bloquant: utilisez SQL Shell."
- duration: 28.0s
- poster: 10s
- transition_in: crossfade
- status: animated
- src: compositions/frames/06-sortir-erreurs.html
- type: troubleshooting
- persuasion: Error prevention
- beat: autonomie
- blueprint: grid-card-assemble (Adapt)
- focal: `\q` puis quatre diagnostics
- roles: terminal = foreground subject; cartes dépannage = foreground supporting; warning = limited accent
- sfx: none

narrativeRole: Donne une sortie propre et une procédure de triage minimale.
keyMessage: `\q` quitte SQL Shell; les problèmes les plus courants se corrigent par mot de passe, service, port ou SQL Shell.
Scene 1 (0.0-7.0s): `postgres=# \q` se tape et le terminal revient à un état fermé.
Scene 2 (7.0-22.0s): quatre cartes apparaissent: mot de passe, service, port, PATH.
Scene 3 (22.0-28.0s): la carte PATH se lie à SQL Shell pour rappeler la solution immédiate.

## Frame 7 - Clôture et suite

- scene: Une carte de confirmation résume la première connexion, puis annonce la préparation de la base et de l'utilisateur de travail.
- voiceover: "Vous avez maintenant validé la première connexion locale. Vous savez ouvrir SQL Shell, accepter les valeurs par défaut, reconnaître l'invite de réussite, lancer des vérifications simples et quitter. Dans l'épisode suivant, nous préparerons la base et l'utilisateur de travail pour les TP."
- duration: 22.0s
- poster: 8s
- transition_in: crossfade
- status: animated
- src: compositions/frames/07-cloture-suite.html
- type: cta
- persuasion: Distillation + handoff
- beat: satisfaction + suite
- blueprint: titlecard-reveal (Adapt)
- focal: confirmation `Connexion locale validée`
- roles: confirmation = foreground subject; liste acquis = foreground supporting; annonce 03/08 = supporting
- sfx: none

narrativeRole: Ferme l'épisode sur les acquis et prépare le prochain TP.
keyMessage: La connexion locale fonctionne; le prochain épisode prépare l'environnement de travail.
Scene 1 (0.0-6.0s): `Connexion locale validée` apparaît en Pine.
Scene 2 (6.0-15.0s): les acquis se cochent en trois lignes: valeurs par défaut, invite, vérifications.
Scene 3 (15.0-22.0s): le rail `03/08 · base et utilisateur de travail` annonce la suite.
