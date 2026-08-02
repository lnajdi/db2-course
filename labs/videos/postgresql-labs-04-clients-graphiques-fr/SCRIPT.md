# SCRIPT - Clients graphiques PostgreSQL

**Voice:** `Audio-Postgresql-labs-04-clients-graphiques-fr.wav` - voix française de l'enseignant, à fournir
**Voice settings:** débit original conservé, articulation nette, pauses pédagogiques
**Voice direction:** Pédagogique, calme et directe. Lire les paramètres de connexion et les requêtes avec assez de précision pour permettre la copie visuelle.

---

## Line 1 - Objectif (Frame 1)

**Time:** 0.0 - 24.0s
**Delivery:** Promesse concrète; poser immédiatement la différence entre compte de travail et compte d'administration.

    Dans les épisodes précédents, nous avons déjà utilisé psql, le client en console. Dans cet épisode, nous passons aux clients graphiques, aussi appelés clients GUI. L'objectif est simple: connecter pagila avec votre utilisateur personnel, par exemple karim, et garder postgres pour l'administration.

## Line 2 - Même serveur, trois clients (Frame 2)

**Time:** 24.0 - 54.0s
**Delivery:** Clarifier le modèle mental client/serveur.

    Un client GUI est seulement une interface graphique pour parler au serveur PostgreSQL. psql faisait déjà ce travail dans la console; pgAdmin, DBeaver et VS Code le font avec des boutons, des formulaires et des grilles. Le serveur, le port et les identifiants restent les mêmes.

## Line 3 - Paramètres communs (Frame 3)

**Time:** 54.0 - 88.0s
**Delivery:** Lent et mémorisable; insister sur le remplacement de `karim`.

    Avant d'ouvrir les logiciels, mémorisez les paramètres communs: hôte localhost, port cinq quatre trois deux, base pagila, utilisateur karim comme exemple. Remplacez karim par votre prénom en minuscules.

## Line 4 - pgAdmin (Frame 4)

**Time:** 88.0 - 134.0s
**Delivery:** Procédural; faire entendre les étapes d'interface sans s'attarder sur l'installation.

    Dans pgAdmin, enregistrez un nouveau serveur: donnez-lui le nom Pagila local, puis dans l'onglet Connection, saisissez localhost, cinq quatre trois deux, pagila, votre utilisateur et votre mot de passe. Ouvrez Query Tool et lancez SELECT étoile FROM film LIMIT dix.

## Line 5 - DBeaver (Frame 5)

**Time:** 134.0 - 178.0s
**Delivery:** Même rythme que pgAdmin; montrer que les paramètres restent identiques.

    Dans DBeaver Community, créez une nouvelle connexion PostgreSQL avec les mêmes paramètres, testez la connexion, puis terminez. Dans l'arborescence, développez pagila, Schemas, public, Tables, ouvrez film, et filtrez les lignes avec rating égal à PG.

## Line 6 - VS Code (Frame 6)

**Time:** 178.0 - 226.0s
**Delivery:** Très précis sur le nom et l'identifiant de l'extension.

    Dans VS Code, cherchez PostgreSQL for Visual Studio Code, par Microsoft. L'identifiant est ms tiret ossdata point vscode tiret pgsql. Après l'installation, ajoutez une connexion PostgreSQL avec les mêmes paramètres, créez queries.sql, puis lancez une requête près de votre code.

## Line 7 - Choisir l'outil (Frame 7)

**Time:** 226.0 - 256.0s
**Delivery:** Ton de conseil; pas de classement absolu.

    Quel outil choisir? pgAdmin est le choix officiel et sûr par défaut. DBeaver est pratique pour explorer les données et exporter. VS Code est confortable quand vos requêtes vivent à côté de votre code.

## Line 8 - Dépannage rapide (Frame 8)

**Time:** 256.0 - 284.0s
**Delivery:** Diagnostic rapide; relier au test psql de l'épisode précédent.

    Si la connexion échoue, vérifiez d'abord le service PostgreSQL, puis le port, le nom de la base, l'utilisateur, et les mots de passe enregistrés. En local, un message SSL peut apparaître: acceptez le mode simple si le cours le demande. Le test de référence reste psql avec localhost, cinq quatre trois deux, karim et pagila.

## Line 9 - Clôture (Frame 9)

**Time:** 284.0 - 300.0s
**Delivery:** Bilan bref et transition vers les requêtes.

    Vous savez maintenant connecter pagila avec un client graphique, parcourir les tables et lancer une première requête. Au prochain épisode, nous utiliserons Pagila pour écrire nos premières vraies requêtes SQL.
