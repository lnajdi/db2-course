# TTS Script - PostgreSQL Installation

## Simple Prompt

Génère une narration française, scène par scène, pour une vidéo pédagogique sur l'installation de PostgreSQL sous Windows. Garde un rythme naturel, clair et rassurant. Respecte strictement le budget de durée de chaque scène. Lis les termes techniques avec soin, conserve les cues inline comme `[short pause]` et `[emphasis]`, et termine chaque scène avec la pause indiquée.

## Timed Production Script

[Scene 01 | 00:00–00:22.7 | friendly | natural pace]
Narration: À la fin de cette vidéo, votre poste Windows sera prêt pour les TP. [short pause] PostgreSQL Server, pgAdmin 4, et les outils en ligne de commande, notamment psql, seront installés. [emphasis] Vous aurez la base nécessaire pour commencer les manipulations.
Pronunciation: PostgreSQL = post-gresse-Q-L; pgAdmin = pi-ji-admin; psql = pi-ess-ku-elle.
End pause: 0.5 seconds

[Scene 02 | 00:22.7–00:52.4 | friendly | natural pace]
Narration: Avant de commencer, vérifiez trois prérequis. [short pause] Utilisez un compte autorisé à installer un service Windows. Gardez une connexion Internet stable. Et préparez un gestionnaire de mots de passe, ou une note privée. [emphasis] Le mot de passe postgres ne sera pas affiché une seconde fois.
Pronunciation: postgres = post-gresse.
End pause: 0.5 seconds

[Scene 03 | 00:52.4–01:26.1 | friendly | natural pace]
Narration: Ouvrez la page officielle postgresql.org, puis la rubrique Download, Windows. [short pause] Choisissez Interactive installer by EDB. C'est l'assistant graphique utilisé dans cette vidéo. Téléchargez la dernière version stable et prise en charge pour Windows x86-64. [emphasis] Évitez les versions de test. Pausez ici pour terminer le téléchargement.
Pronunciation: postgresql.org = post-gresse-Q-L point org; EDB = i-di-bi; x86-64 = ex quatre-vingt-six, soixante-quatre.
End pause: 0.5 seconds

[Scene 04 | 01:26.1–02:04.7 | friendly | natural pace]
Narration: Exécutez le fichier en tant qu'administrateur et acceptez la demande de Windows. [short pause] Conservez les dossiers proposés. Cela évite les problèmes de droits et simplifie les prochains TP. Dans Select Components, gardez PostgreSQL Server, qui exécute la base de données; pgAdmin 4, l'interface graphique; et Command Line Tools, qui contient notamment psql. [emphasis] Stack Builder ajoute des pilotes et extensions. Il reste optionnel pour le moment.
Pronunciation: Select Components = sélecte components; PostgreSQL = post-gresse-Q-L; pgAdmin = pi-ji-admin; Command Line Tools = command line touls; psql = pi-ess-ku-elle; Stack Builder = stack builder.
End pause: 0.5 seconds

[Scene 05 | 02:04.7–02:45.8 | friendly | natural pace]
Narration: Sur l'écran Password, créez un mot de passe solide pour le superutilisateur postgres. [short pause] Saisissez-le deux fois et conservez-le. Il protège le compte d'administration et sera demandé lors de la première connexion. [emphasis] Pausez ici avant de continuer. Gardez ensuite le port 5432. C'est le port PostgreSQL par défaut. Conservez aussi la locale proposée par Windows; elle définit notamment les règles de tri et de formatage du nouveau cluster.
Pronunciation: Password = password; postgres = post-gresse; 5432 = cinq quatre trois deux; PostgreSQL = post-gresse-Q-L.
End pause: 0.5 seconds

[Scene 06 | 02:45.8–03:23.6 | friendly | natural pace]
Narration: Avant l'installation, relisez le résumé: composants, dossiers, port et locale. [short pause] Utilisez Back si une valeur est incorrecte; sinon, cliquez sur Next. L'assistant copie les fichiers, initialise le cluster et démarre PostgreSQL comme service Windows. Attendez le message de réussite. Sur le dernier écran, décochez Launch Stack Builder at exit, puis cliquez sur Finish. [emphasis] Vous pourrez toujours ouvrir Stack Builder plus tard.
Pronunciation: Back = back; Next = next; PostgreSQL = post-gresse-Q-L; Launch Stack Builder at exit = launch stack builder at exit; Finish = finish; Stack Builder = stack builder.
End pause: 0.5 seconds

[Scene 07 | 03:23.6–03:47.6 | friendly | natural pace]
Narration: L'installation est terminée lorsque SQL Shell, psql, et pgAdmin 4 apparaissent dans le menu Démarrer. [short pause] Si la commande psql n'est pas reconnue dans un terminal ordinaire, ce n'est pas un échec: l'installateur ne modifie pas automatiquement le PATH. [emphasis] Dans l'épisode suivant, nous utiliserons SQL Shell pour effectuer la première connexion.
Pronunciation: SQL Shell = ess-ku-elle shell; psql = pi-ess-ku-elle; pgAdmin = pi-ji-admin; PATH = path.
End pause: 0.5 seconds

## Clean TTS-Ready Script

À la fin de cette vidéo, votre poste Windows sera prêt pour les TP. [short pause] PostgreSQL Server, pgAdmin 4, et les outils en ligne de commande, notamment psql, seront installés. [emphasis] Vous aurez la base nécessaire pour commencer les manipulations.

Avant de commencer, vérifiez trois prérequis. [short pause] Utilisez un compte autorisé à installer un service Windows. Gardez une connexion Internet stable. Et préparez un gestionnaire de mots de passe, ou une note privée. [emphasis] Le mot de passe postgres ne sera pas affiché une seconde fois.

Ouvrez la page officielle postgresql.org, puis la rubrique Download, Windows. [short pause] Choisissez Interactive installer by EDB. C'est l'assistant graphique utilisé dans cette vidéo. Téléchargez la dernière version stable et prise en charge pour Windows x86-64. [emphasis] Évitez les versions de test. Pausez ici pour terminer le téléchargement.

Exécutez le fichier en tant qu'administrateur et acceptez la demande de Windows. [short pause] Conservez les dossiers proposés. Cela évite les problèmes de droits et simplifie les prochains TP. Dans Select Components, gardez PostgreSQL Server, qui exécute la base de données; pgAdmin 4, l'interface graphique; et Command Line Tools, qui contient notamment psql. [emphasis] Stack Builder ajoute des pilotes et extensions. Il reste optionnel pour le moment.

Sur l'écran Password, créez un mot de passe solide pour le superutilisateur postgres. [short pause] Saisissez-le deux fois et conservez-le. Il protège le compte d'administration et sera demandé lors de la première connexion. [emphasis] Pausez ici avant de continuer. Gardez ensuite le port 5432. C'est le port PostgreSQL par défaut. Conservez aussi la locale proposée par Windows; elle définit notamment les règles de tri et de formatage du nouveau cluster.

Avant l'installation, relisez le résumé: composants, dossiers, port et locale. [short pause] Utilisez Back si une valeur est incorrecte; sinon, cliquez sur Next. L'assistant copie les fichiers, initialise le cluster et démarre PostgreSQL comme service Windows. Attendez le message de réussite. Sur le dernier écran, décochez Launch Stack Builder at exit, puis cliquez sur Finish. [emphasis] Vous pourrez toujours ouvrir Stack Builder plus tard.

L'installation est terminée lorsque SQL Shell, psql, et pgAdmin 4 apparaissent dans le menu Démarrer. [short pause] Si la commande psql n'est pas reconnue dans un terminal ordinaire, ce n'est pas un échec: l'installateur ne modifie pas automatiquement le PATH. [emphasis] Dans l'épisode suivant, nous utiliserons SQL Shell pour effectuer la première connexion.

## Pronunciation Glossary

- PostgreSQL: post-gresse-Q-L
- postgres: post-gresse
- pgAdmin: pi-ji-admin
- psql: pi-ess-ku-elle
- SQL Shell: ess-ku-elle shell
- EDB: i-di-bi
- x86-64: ex quatre-vingt-six, soixante-quatre
- PATH: path
- Command Line Tools: command line touls
- Stack Builder: stack builder
- Back: back
- Next: next
- Finish: finish
