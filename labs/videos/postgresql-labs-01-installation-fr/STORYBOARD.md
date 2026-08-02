---
format: 1920x1080
duration: 227.6s
message: "Installer correctement PostgreSQL Server, pgAdmin 4 et les outils en ligne de commande sous Windows pour commencer les TP"
arc: how-to-process
audience: "débutants utilisant Windows 10 ou Windows 11"
mode: automation
music: none
captions: embedded-fr
caption_keepout: "y=880–1080"
---

## Video direction

- Palette: canvas chaud et surfaces claires depuis `frame.md`; Atlantic blue pour les actions et les transitions; Pine green uniquement pour les confirmations; Walnut pour une note éditoriale rare; warning/danger seulement pour les alertes. Les composants consomment uniquement les variables sémantiques.
- Typographie: rôle display pour les titres Literata, rôle body pour les explications Instrument Sans, rôle mono pour les chemins, ports, compte `postgres` et libellés techniques Geist Mono.
- Motion grammar: entrées calmes sur décélération longue; chaque élément arrive au moment où la voix le nomme, surtout dans la seconde moitié du plan. Aucun élément ne respire en boucle; pendant les holds, tout reste fixe ou reçoit au plus un jitter très discret et fini.
- Continuité: les frames 03 à 06 partagent la même géométrie de fenêtre; les transitions `push-slide LEFT` donnent l’impression d’avancer dans un seul wizard. Aucune animation de sortie interne avant la transition du harness.
- Rhythm: la frame 03 offre une pause de téléchargement; la frame 05 offre une pause de mot de passe; les frames 06 et 07 se terminent par un hold lisible. La bande `y=880–1080` reste libre de tout contenu critique.
- Negative list: aucune capture réelle, logo externe, photo, bokeh, gradient IA violet/bleu, jump cut, mouvement de screensaver, animation front-loadée puis figée, pan lent en fin de plan ou rebond par défaut.

## Frame 1 — Prêt pour les TP

- scene: Le titre s’assemble autour de trois résultats visibles: Server, pgAdmin 4 et Command Line Tools.
- voiceover: "À la fin de cette vidéo, votre poste Windows sera prêt pour les TP : PostgreSQL Server, pgAdmin 4 et les outils en ligne de commande, notamment psql, seront installés."
- duration: 22.7s
- poster: 5s
- transition_in: cut
- status: animated
- src: compositions/frames/01-pret-pour-les-tp.html
- type: hook
- persuasion: Stakes / consequence + Rule of three
- beat: anticipation + confiance
- blueprint: kinetic-type-beats (Adapt)
- focal: le triptyque PostgreSQL Server · pgAdmin 4 · Command Line Tools
- roles: titre = foreground subject · trois cartes = foreground supporting · canvas chaud + grille très légère = background
- sfx: soft-confirm

narrativeRole: Ouvre sur le résultat concret attendu et donne immédiatement une raison de suivre les étapes.
keyMessage: Trois composants suffisent pour commencer les TP.

Adapt: conserver le moteur de beats typographiques, mais les trois beats deviennent des cartes persistantes qui s’assemblent à droite du titre.
Scene 1 (0.0–5.7s): le kicker `01/08 · INSTALLATION` puis « Bien démarrer les TP » se révèlent par groupes de mots (`dynamic-content-sequencing`) dans un cadrage asymétrique 60/40; seule la promesse est visible.
Scene 2 (5.7–14.2s): quand la voix les nomme, les cartes Server, pgAdmin 4 et Command Line Tools glissent chacune directement dans son emplacement (`center-outward-expansion`, chemin court), une par une, sur trois profondeurs.
Scene 3 (14.2–22.7s): un trait Atlantic relie les trois cartes au titre, le groupe se verrouille et tient fixe; Pine n’apparaît pas encore, car rien n’est confirmé.

## Frame 2 — Trois prérequis

- scene: Trois cartes de prérequis se rangent sur un bureau visuel: droits administrateur, Internet et coffre de mot de passe.
- voiceover: "Avant de commencer, vérifiez trois prérequis. Utilisez un compte autorisé à installer un service Windows, gardez une connexion Internet stable et préparez un gestionnaire de mots de passe, ou une note privée. Le mot de passe postgres ne sera pas affiché une seconde fois."
- duration: 29.7s
- poster: 8s
- transition_in: crossfade
- status: animated
- src: compositions/frames/02-trois-prerequis.html
- type: pain_point
- persuasion: Numbered enumeration + Risk reduction
- beat: orientation
- blueprint: grid-card-assemble (Reproduce)
- focal: les trois cartes de prérequis
- roles: cartes = foreground subject · numéros = supporting · titre + trame de bureau = midground · canvas chaud = background
- sfx: card-ticks

narrativeRole: Prévient les trois blocages qui interrompent le plus souvent une première installation.
keyMessage: Les droits, le réseau et la conservation du mot de passe doivent être prêts avant le téléchargement.

Scene 1 (0.0–5.0s): le titre « Avant de lancer l’installateur » arrive seul en haut sur un cadrage triptyque encore vide; reveal par mots (`dynamic-content-sequencing`).
Scene 2 (5.0–11.0s): la carte `01 · Droits administrateur` glisse sur un chemin court dans son slot (`center-outward-expansion`) et tient.
Scene 3 (11.0–18.0s): la carte `02 · Connexion Internet` rejoint le triptyque avec le même mouvement et un tick discret.
Scene 4 (18.0–25.0s): la carte `03 · Mot de passe` se place; Walnut souligne uniquement la notion de conservation sûre.
Scene 5 (25.0–29.7s): les trois cartes reçoivent une fine ligne d’état commune et tiennent sans flotter; la hiérarchie reste 3:1 entre le titre et les explications.

## Frame 3 — Le bon téléchargement

- scene: Une page officielle reconstruite conduit vers Interactive installer by EDB, puis isole Windows x86-64 avec un marqueur Pausez ici.
- voiceover: "Ouvrez la page officielle postgresql.org, puis la rubrique Download, Windows. Choisissez Interactive installer by EDB : c’est l’assistant graphique utilisé dans cette vidéo. Téléchargez la dernière version stable et prise en charge pour Windows x86-64. Évitez les versions de test. Pausez ici pour terminer le téléchargement."
- duration: 33.7s
- poster: 10s
- transition_in: zoom-through
- status: animated
- src: compositions/frames/03-bon-telechargement.html
- type: product_intro
- persuasion: Progressive disclosure + Source anchoring
- beat: clarté
- blueprint: device-surface-showcase (Adapt)
- focal: le choix `Interactive installer by EDB` dans la page officielle reconstruite
- roles: page officielle = foreground subject · rail Pausez ici = foreground supporting · URL et architecture x86-64 = mono supporting · canvas chaud = background
- sfx: soft-click

narrativeRole: Élimine l’ambiguïté entre les options de téléchargement et rend le choix de l’architecture mémorisable.
keyMessage: Le bon fichier vient de la page officielle, via l’installateur interactif EDB pour Windows x86-64.

Adapt: garder la surface persistante et ses états successifs; remplacer la visite de produit par une reconstruction volontairement simplifiée de la page officielle, sans logo ni chrome superflu.
Scene 1 (0.0–7.0s): la page officielle glisse depuis le bas et se pose dans un cadrage 70/30 (`card-morph-anchor`); seule l’URL mono et le titre Windows installers sont lisibles.
Scene 2 (7.0–16.0s): un focus Atlantic progresse vers `Interactive installer by EDB`; la surface interne translate légèrement dans sa fenêtre masquée (`3d-page-scroll`) sans déplacer la caméra.
Scene 3 (16.0–26.0s): la ligne `Windows x86-64 · dernière version prise en charge` se révèle à son tour par état discret (`discrete-text-sequence`) et tient.
Scene 4 (26.0–33.7s): le rail warning « PAUSEZ ICI » se déploie à droite (`anchored-layout-expand`), puis l’ensemble reste parfaitement fixe pour permettre le téléchargement.

## Frame 4 — Dossiers et composants

- scene: La même fenêtre d’installateur avance de Welcome à Select Components; les trois composants requis restent cochés et Stack Builder est annoté optionnel.
- voiceover: "Exécutez le fichier en tant qu’administrateur et acceptez la demande de Windows. Conservez les dossiers proposés : cela évite les problèmes de droits et simplifie les prochains TP. Dans Select Components, gardez PostgreSQL Server, qui exécute la base de données; pgAdmin 4, l’interface graphique; et Command Line Tools, qui contient notamment psql. Stack Builder ajoute des pilotes et extensions; il reste optionnel pour le moment."
- duration: 38.6s
- poster: 15s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/04-dossiers-composants.html
- type: feature_showcase
- persuasion: Demonstration + Comparison of required versus optional
- beat: compréhension + confiance
- blueprint: cursor-ui-demo (Adapt)
- focal: la fenêtre Select Components et ses quatre cases
- roles: fenêtre installateur = foreground subject · curseur = supporting actor · rail requis/optionnel = foreground supporting · étapes du wizard = midground
- sfx: checkbox-ticks

narrativeRole: Guide la première partie du wizard et distingue clairement les composants indispensables de l’utilitaire complémentaire.
keyMessage: Garder les chemins par défaut et les trois composants requis évite les erreurs de configuration de départ.

Adapt: employer la variante static-stage; la caméra reste verrouillée et un curseur unique conduit les changements d’état dans une fenêtre reconstruite.
Scene 1 (0.0–7.0s): la fenêtre `PostgreSQL Setup` s’établit à gauche, cadrage 70/30; `Welcome` puis `Installation Directory` se succèdent par scale-swap discret (`scale-swap-transition`), sans sortie de frame.
Scene 2 (7.0–15.0s): le curseur se pose sur les chemins proposés et un label « Conserver » apparaît dans le rail (`cursor-click-ripple`, amplitude sobre); la caméra reste fixe.
Scene 3 (15.0–26.0s): l’écran `Select Components` prend la place au même ancrage; les cases PostgreSQL Server, pgAdmin 4 et Command Line Tools se mettent en évidence l’une après l’autre (`dynamic-content-sequencing`).
Scene 4 (26.0–34.0s): Stack Builder reste visible mais passe en style secondaire; le rail oppose « 3 requis » à « optionnel » sans masquer la fenêtre.
Scene 5 (34.0–38.6s): la sélection complète tient; une fine confirmation Pine encadre uniquement les trois composants requis, sans animation continue.

## Frame 5 — Mot de passe, port, locale

- scene: La fenêtre partagée passe de Password à Port puis Advanced Options; le mot de passe est masqué, 5432 est verrouillé et la locale reste sur Default locale.
- voiceover: "Sur l’écran Password, créez un mot de passe solide pour le superutilisateur postgres, saisissez-le deux fois et conservez-le. Il protège le compte d’administration et sera demandé lors de la première connexion. Pausez ici avant de continuer. Gardez ensuite le port 5432 : c’est le port PostgreSQL par défaut. Conservez aussi la locale proposée par Windows; elle définit notamment les règles de tri et de formatage du nouveau cluster."
- duration: 41.1s
- poster: 16s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/05-mot-de-passe-port-locale.html
- type: feature_showcase
- persuasion: Progressive disclosure + Anchoring on default values
- beat: vigilance + maîtrise
- blueprint: panel-edit-live-sync (Adapt)
- focal: le formulaire Password couplé aux valeurs Port 5432 et Default locale
- roles: formulaire = foreground subject · rail des valeurs = foreground supporting · curseur/caret = supporting actor · fenêtre persistante = midground
- sfx: field-focus

narrativeRole: Sécurise les trois choix qui conditionnent les connexions futures sans surcharger le débutant de configuration avancée.
keyMessage: Conserver le mot de passe postgres, le port 5432 et la locale par défaut.

Adapt: garder le couple panneau-cible simultané, mais le panneau résume ici les valeurs à conserver plutôt que de piloter une transformation graphique.
Scene 1 (0.0–8.0s): la même géométrie d’installateur arrive sur `Password`; le label `postgres` est introduit en mono, la zone de saisie reste vide et le rail 30% est encore neutre.
Scene 2 (8.0–19.0s): le marqueur warning « PAUSEZ ICI » s’ouvre au-dessus des deux champs (`anchored-layout-expand`); les puces apparaissent par seuils de saisie (`discrete-text-sequence`) et le rail rappelle « Conserver ce mot de passe ».
Scene 3 (19.0–30.0s): la fenêtre passe à `Port` au même ancrage (`scale-swap-transition`); le champ `5432` et sa copie dans le rail s’allument simultanément (`control-target-sync`).
Scene 4 (30.0–36.0s): `Advanced Options` remplace l’état; `Default locale` est sélectionné et le rail se synchronise au même beat (`control-target-sync`).
Scene 5 (36.0–41.1s): les trois résultats — mot de passe conservé, 5432, locale proposée — se verrouillent en Pine et tiennent; aucun mouvement de caméra tardif.

## Frame 6 — Installer et terminer

- scene: Le résumé se relit, une barre de progression s’achève, puis Launch Stack Builder at exit est décoché avant Finish.
- voiceover: "Avant l’installation, relisez le résumé : composants, dossiers, port et locale. Utilisez Back si une valeur est incorrecte; sinon, cliquez sur Next. L’assistant copie les fichiers, initialise le cluster et démarre PostgreSQL comme service Windows. Attendez le message de réussite. Sur le dernier écran, décochez Launch Stack Builder at exit, puis cliquez sur Finish. Vous pourrez toujours ouvrir Stack Builder plus tard."
- duration: 37.8s
- poster: 17s
- transition_in: push-slide LEFT
- status: animated
- src: compositions/frames/06-installer-terminer.html
- type: feature_showcase
- persuasion: Causal chain + Demonstration
- beat: progression + soulagement
- blueprint: agent-progress-theater (Adapt)
- focal: la barre d’installation qui progresse jusqu’à `Installation completed successfully`
- roles: fenêtre installateur = foreground subject · résumé = supporting · progression = working-state focal · choix Stack Builder = foreground supporting
- sfx: progress-complete

narrativeRole: Conduit l’installation jusqu’à son terme et explique pourquoi Stack Builder peut être ignoré sans risque pour les premiers TP.
keyMessage: Une installation terminée n’exige pas d’ouvrir Stack Builder.

Adapt: conserver le théâtre de progression puis le reçu final; remplacer le travail d’agent par les phases réelles du wizard.
Scene 1 (0.0–7.0s): `Pre Installation Summary` s’affiche dans la fenêtre persistante, cadrage 70/30; les lignes Components, Port et Locale se révèlent l’une après l’autre (`dynamic-content-sequencing`).
Scene 2 (7.0–14.0s): `Ready to Install` remplace le titre et le bouton Next reçoit une pression unique (`press-release-spring`); ensuite le curseur disparaît.
Scene 3 (14.0–27.0s): la barre de progression se remplit par paliers (`stat-bars-and-fills`) pendant que trois libellés d’état se succèdent; cette animation diegétique cesse exactement à la fin.
Scene 4 (27.0–33.0s): la confirmation `Installation completed successfully` apparaît en Pine; la barre est pleine, toute activité s’arrête et le reçu tient.
Scene 5 (33.0–37.8s): le rail isole `☐ Launch Stack Builder at exit` et le laisse décoché; la justification « disponible plus tard » arrive puis tient sans drift.

## Frame 7 — Installation terminée

- scene: Une carte de confirmation affiche SQL Shell (psql) et pgAdmin 4 dans un menu Démarrer stylisé, puis annonce l’épisode 02.
- voiceover: "L’installation est terminée lorsque SQL Shell, psql, et pgAdmin 4 apparaissent dans le menu Démarrer. Si la commande psql n’est pas reconnue dans un terminal ordinaire, ce n’est pas un échec : l’installateur ne modifie pas automatiquement le PATH. Dans l’épisode suivant, nous utiliserons SQL Shell pour effectuer la première connexion."
- duration: 24.0s
- poster: 10s
- transition_in: crossfade
- status: animated
- src: compositions/frames/07-installation-terminee.html
- type: cta
- persuasion: Distillation + Callback
- beat: satisfaction + anticipation
- blueprint: titlecard-reveal (Adapt)
- focal: la confirmation `Installation terminée` avec SQL Shell (psql) et pgAdmin 4
- roles: titre de confirmation = foreground subject · menu Démarrer stylisé = foreground supporting · annonce 02/08 = supporting · canvas chaud + halo Pine discret = background
- sfx: success-chime

narrativeRole: Donne un critère de réussite observable et ouvre naturellement vers l’épisode consacré à psql.
keyMessage: L’installation est réussie lorsque SQL Shell et pgAdmin 4 sont visibles dans le menu Démarrer.

Adapt: conserver un seul reveal calme suivi d’un long hold; le contenu est une carte de réussite plutôt qu’un lockup de marque.
Scene 1 (0.0–2.0s): `✓ INSTALLATION TERMINÉE` et « Vous êtes prêt » entrent par un reveal retenu (`scale-swap-transition`) dans un cadrage asymétrique 55/45; Pine est utilisé uniquement ici comme confirmation.
Scene 2 (2.0–5.0s): le menu Démarrer stylisé se révèle; SQL Shell (psql) puis pgAdmin 4 apparaissent sur leurs cues (`dynamic-content-sequencing`), sans logo ni photo.
Scene 3 (5.0–16.6s): la note PATH est explicitée: si `psql` n’est pas reconnu dans un terminal ordinaire, ce n’est pas un échec; l’installateur ne modifie pas automatiquement le PATH.
Scene 4 (16.6–24.0s): la carte `02/08 · Premiers pas avec psql` glisse dans le rail gauche; l’ensemble tient parfaitement fixe jusqu’à la fin, sans respiration ni sortie.
