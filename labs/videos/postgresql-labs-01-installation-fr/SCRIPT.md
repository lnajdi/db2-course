# SCRIPT — Installer PostgreSQL sous Windows

**Voice:** `Audio-Postgresql-labs-01-installation-fr.wav` — voix française de l’enseignant
**Voice settings:** débit original conservé, articulation nette
**Voice direction:** Pédagogique, rassurante et directe. Chaque passage suit le rythme « action, raison, résultat attendu ». Marquer une courte pause entre ces trois informations.

---

## Line 1 — Prêt pour les TP (Frame 1)

**Time:** 0.0 – 22.7s
**Delivery:** Promesse simple. Bien détacher les quatre noms techniques.

    À la fin de cette vidéo, votre poste Windows sera prêt pour les TP : PostgreSQL Server, pgAdmin 4 et les outils en ligne de commande, notamment psql, seront installés.

## Line 2 — Trois prérequis (Frame 2)

**Time:** 22.7 – 52.4s
**Delivery:** Énumération posée; faire entendre la raison de chaque prérequis.

    Avant de commencer, vérifiez trois prérequis. Utilisez un compte autorisé à installer un service Windows, gardez une connexion Internet stable et préparez un gestionnaire de mots de passe, ou une note privée. Le mot de passe postgres ne sera pas affiché une seconde fois.

## Line 3 — Le bon téléchargement (Frame 3)

**Time:** 52.4 – 86.1s
**Delivery:** Lire les libellés techniques exactement et ralentir sur l’architecture.

    Ouvrez la page officielle postgresql.org, puis la rubrique Download, Windows. Choisissez Interactive installer by EDB : c’est l’assistant graphique utilisé dans cette vidéo. Téléchargez la dernière version stable et prise en charge pour Windows x86-64. Évitez les versions de test. Pausez ici pour terminer le téléchargement.

## Line 4 — Dossiers et composants (Frame 4)

**Time:** 86.1 – 124.7s
**Delivery:** Associer chaque composant à son utilité, sans accélérer la liste.

    Exécutez le fichier en tant qu’administrateur et acceptez la demande de Windows. Conservez les dossiers proposés : cela évite les problèmes de droits et simplifie les prochains TP. Dans Select Components, gardez PostgreSQL Server, qui exécute la base de données; pgAdmin 4, l’interface graphique; et Command Line Tools, qui contient notamment psql. Stack Builder ajoute des pilotes et extensions; il reste optionnel pour le moment.

## Line 5 — Mot de passe, port, locale (Frame 5)

**Time:** 124.7 – 165.8s
**Delivery:** Ralentir nettement sur le mot de passe, puis présenter les valeurs par défaut comme des repères.

    Sur l’écran Password, créez un mot de passe solide pour le superutilisateur postgres, saisissez-le deux fois et conservez-le. Il protège le compte d’administration et sera demandé lors de la première connexion. Pausez ici avant de continuer. Gardez ensuite le port 5432 : c’est le port PostgreSQL par défaut. Conservez aussi la locale proposée par Windows; elle définit notamment les règles de tri et de formatage du nouveau cluster.

## Line 6 — Installer et terminer (Frame 6)

**Time:** 165.8 – 203.6s
**Delivery:** Progression calme; décrire les signes visibles de réussite.

    Avant l’installation, relisez le résumé : composants, dossiers, port et locale. Utilisez Back si une valeur est incorrecte; sinon, cliquez sur Next. L’assistant copie les fichiers, initialise le cluster et démarre PostgreSQL comme service Windows. Attendez le message de réussite. Sur le dernier écran, décochez Launch Stack Builder at exit, puis cliquez sur Finish. Vous pourrez toujours ouvrir Stack Builder plus tard.

## Line 7 — Installation terminée (Frame 7)

**Time:** 203.6 – 211.3s
**Delivery:** Satisfaction sobre; bien distinguer le critère de réussite et la limite de cet épisode.

    L’installation est terminée lorsque SQL Shell, psql, et pgAdmin 4 apparaissent dans le menu Démarrer. Si la commande psql n’est pas reconnue dans un terminal ordinaire, ce n’est pas un échec : l’installateur ne modifie pas automatiquement le PATH. Dans l’épisode suivant, nous utiliserons SQL Shell pour effectuer la première connexion.
