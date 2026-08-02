# SCRIPT - Préparer Pagila et son utilisateur personnel

**Voice:** `Audio-Postgresql-labs-03-pagila-utilisateur-fr.wav` - voix française de l'enseignant, à fournir
**Voice settings:** débit original conservé, articulation nette, pauses pédagogiques
**Voice direction:** Pédagogique, calme et directe. Lire les commandes avec assez de précision pour permettre la copie visuelle, sans épeler chaque caractère des longues lignes.

---

## Line 1 - Objectif de l'épisode (Frame 1)

**Time:** 0.0 - 24.0s
**Delivery:** Promesse concrète; distinguer clairement base, fichiers et utilisateur.

    Dans cet épisode, nous préparons l'environnement Pagila pour les TP. À la fin, vous aurez une base de données pagila prête, les fichiers officiels importés dans le bon ordre, et un utilisateur personnel pour travailler sans rester connecté comme postgres.

## Line 2 - Créer le dossier et télécharger les fichiers officiels (Frame 2)

**Time:** 24.0 - 72.0s
**Delivery:** Ton procédural; insister sur le fait que les fichiers restent officiels et inchangés.

    Créez le dossier C deux-points anti-slash Pagila underscore Project. Ouvrez le dépôt officiel Pagila à l'adresse github point com slash devrimgunduz slash pagila, puis ouvrez les fichiers raw pagila-schema.sql et pagila-data.sql. Faites clic droit, enregistrer sous, gardez exactement ces deux noms de fichiers, et placez-les dans C deux-points anti-slash Pagila underscore Project. Ne modifiez pas ces fichiers: ils seront importés exactement comme ils ont été téléchargés.

## Line 3 - Créer la base en tant que postgres (Frame 3)

**Time:** 72.0 - 102.0s
**Delivery:** Calme; expliquer pourquoi `postgres` est utilisé ici.

    Ouvrez SQL Shell et connectez-vous avec l'utilisateur postgres. Ici, postgres sert au travail de préparation et d'administration. Créez la base avec CREATE DATABASE pagila, point-virgule, puis connectez-vous à cette base avec anti-slash c pagila.

## Line 4 - Importer le schéma officiel (Frame 4)

**Time:** 102.0 - 142.0s
**Delivery:** Lire la commande lentement; expliquer l'action, la raison et le résultat attendu.

    Importez d'abord le schéma. Dans psql, les chemins Windows s'écrivent avec des slashs, pas avec des anti-slashs. Tapez anti-slash i, espace, apostrophe, C deux-points slash Pagila underscore Project slash pagila-schema.sql, apostrophe. Cette étape crée les tables, les clés et les contraintes. Elle doit réussir avant les données.

## Line 5 - Importer les données officielles (Frame 5)

**Time:** 142.0 - 178.0s
**Delivery:** Rassurer sur la sortie longue; insister sur l'attente du retour de l'invite.

    Ensuite seulement, importez les données avec anti-slash i, espace, apostrophe, C deux-points slash Pagila underscore Project slash pagila-data.sql, apostrophe. Les données remplissent les tables qui existent déjà. Vous verrez beaucoup de lignes insert ou copy défiler. Attendez que l'invite pagila dièse revienne avant de continuer.

## Line 6 - Créer son utilisateur personnel (Frame 6)

**Time:** 178.0 - 220.0s
**Delivery:** Très explicite sur l'exemple `karim`, le remplacement et la confidentialité.

    Après l'import, restez connecté comme postgres et créez votre utilisateur personnel. Karim est seulement un exemple: chaque étudiant remplace karim par son propre prénom en minuscules. Choisissez un mot de passe privé et ne le partagez pas. Ensuite, accordez les droits sur la base pagila, le schéma public, les tables et les séquences.

## Line 7 - Se connecter comme utilisateur de TP (Frame 7)

**Time:** 220.0 - 252.0s
**Delivery:** Montrer le passage de l'administration vers le compte de travail.

    Pour vérifier le compte de TP, ouvrez un terminal CMD et lancez psql tiret h localhost tiret p cinq quatre trois deux tiret U karim tiret d pagila. Tiret h indique l'hôte, tiret p le port, tiret U l'utilisateur, et tiret d la base de données. Si psql n'est pas reconnu, revoyez le PATH ou utilisez SQL Shell; la commande à comprendre reste psql suivi de ces paramètres.

## Line 8 - Comprendre les méta-commandes psql (Frame 8)

**Time:** 252.0 - 276.0s
**Delivery:** Définir simplement les commandes avec anti-slash; distinguer SQL et console.

    Avant la dernière vérification, retenez ceci: les commandes qui commencent par anti-slash sont des méta-commandes de psql. Elles ne sont pas du SQL et elles ne prennent pas de point-virgule. Anti-slash d t liste les tables, anti-slash d suivi d'un nom décrit un objet, anti-slash d u liste les utilisateurs, anti-slash c change de base, et anti-slash q quitte la console.

## Line 9 - Vérifier et dépanner (Frame 9)

**Time:** 276.0 - 296.0s
**Delivery:** Bilan rapide; donner le diagnostic `OWNER TO student` sans inviter à éditer le fichier.

    Une fois connecté à pagila, tapez anti-slash d t pour lister les tables, puis SELECT COUNT étoile FROM film, point-virgule. Si le schéma mentionne OWNER TO student, vous n'avez pas le fichier officiel: téléchargez à nouveau pagila-schema.sql depuis Pagila, au lieu de modifier le fichier.
