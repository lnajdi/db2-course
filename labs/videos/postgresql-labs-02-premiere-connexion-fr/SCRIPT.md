# SCRIPT - Première connexion avec SQL Shell

**Voice:** `Audio-Postgresql-labs-02-premiere-connexion-fr.wav` - voix française de l'enseignant, à fournir
**Voice settings:** débit original conservé, articulation nette, pauses pédagogiques
**Voice direction:** Pédagogique, calme et directe. Lire les prompts et commandes exactement. Marquer une courte pause avant chaque action tapée dans le terminal.

---

## Line 1 - Objectif de l'épisode (Frame 1)

**Time:** 0.0 - 22.0s
**Delivery:** Promesse simple; détacher les cinq résultats attendus.

    Dans cet épisode, nous allons faire la première connexion locale à PostgreSQL avec SQL Shell. À la fin, vous saurez ouvrir l'outil, répondre aux prompts, reconnaître l'invite postgres égal dièse, lancer une première vérification, puis sortir proprement.

## Line 2 - Ouvrir SQL Shell (Frame 2)

**Time:** 22.0 - 46.0s
**Delivery:** Ton pratique; insister sur l'intérêt de SQL Shell pour éviter le PATH.

    Ouvrez le menu Démarrer de Windows et cherchez SQL Shell, entre parenthèses psql. Utilisez cette entrée pour commencer. Elle lance le client installé avec PostgreSQL et évite les problèmes de PATH dans un terminal ordinaire.

## Line 3 - Répondre aux prompts (Frame 3)

**Time:** 46.0 - 78.0s
**Delivery:** Lire chaque valeur par défaut lentement; ralentir sur le mot de passe masqué.

    SQL Shell pose ensuite quelques questions. Pour une installation locale standard, appuyez sur Entrée pour accepter localhost, puis postgres, puis 5432, puis encore postgres. Quand le mot de passe est demandé, tapez celui que vous avez créé pendant l'installation. Il ne s'affiche pas pendant la saisie: c'est normal.

## Line 4 - Reconnaître une connexion réussie (Frame 4)

**Time:** 78.0 - 102.0s
**Delivery:** Ton de confirmation; expliquer l'invite sans surcharger.

    Si la connexion réussit, vous voyez l'invite postgres égal dièse. Le mot postgres indique la base de données courante. Le symbole dièse indique ici une session superutilisateur. À partir de cette invite, SQL Shell attend vos commandes.

## Line 5 - Lancer les premières commandes (Frame 5)

**Time:** 102.0 - 140.0s
**Delivery:** Lire les commandes exactement; préciser que c'est de la vérification.

    Pour vérifier que tout répond, tapez SELECT version, parenthèse ouvrante, parenthèse fermante, point-virgule, puis Entrée. La commande affiche la version du serveur PostgreSQL. Tapez ensuite anti-slash conninfo pour voir à quelle base, avec quel utilisateur et sur quel port vous êtes connecté. Enfin, anti-slash elle affiche la liste des bases. Ici, l'objectif est seulement de vérifier la connexion, pas encore d'apprendre SQL.

## Line 6 - Sortir et corriger les erreurs fréquentes (Frame 6)

**Time:** 140.0 - 168.0s
**Delivery:** Concis; séparer sortie et dépannage.

    Pour quitter SQL Shell, tapez anti-slash q puis Entrée. Si la connexion échoue, vérifiez d'abord le mot de passe. Si le serveur ne répond pas, vérifiez que le service PostgreSQL est démarré. Si vous avez changé le port pendant l'installation, indiquez ce port. Et si psql n'est pas reconnu dans un terminal ordinaire, ce n'est pas bloquant: utilisez SQL Shell.

## Line 7 - Clôture et suite (Frame 7)

**Time:** 168.0 - 190.0s
**Delivery:** Bilan sobre; annoncer la suite sans ajouter de nouvelle manipulation.

    Vous avez maintenant validé la première connexion locale. Vous savez ouvrir SQL Shell, accepter les valeurs par défaut, reconnaître l'invite de réussite, lancer des vérifications simples et quitter. Dans l'épisode suivant, nous préparerons la base et l'utilisateur de travail pour les TP.
