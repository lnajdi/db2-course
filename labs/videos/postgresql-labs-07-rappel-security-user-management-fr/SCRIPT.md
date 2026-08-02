# SCRIPT - Rappel Roles, Schemas et Securite PostgreSQL

**Voice:** `Audio-Postgresql-labs-07-rappel-security-user-management-fr.wav` - voix francaise de l'enseignant, a fournir
**Voice settings:** debit naturel, articulation nette, pauses pedagogiques
**Voice direction:** Pedagogique, calme et directe. L'episode confirme les concepts avant le lab; ne pas donner une correction.
**Sources:** `../lab03-PostgreSQL-Security-UserManagement/README.md` et `../lab03-PostgreSQL-Security-UserManagement/lab03-PostgreSQL-Security-UserManagement.sql`

---

## Line 1 - Pourquoi ce rappel ? (Frame 1)

**Time:** 0.0 - 30.0s
**Delivery:** Poser le cadre: rappel conceptuel, pas correction.

    Avant de commencer le lab securite et gestion des utilisateurs, faisons un rappel. L'objectif n'est pas de corriger les exercices. L'objectif est de verifier le modele mental: qui se connecte a PostgreSQL, ce que cette identite a le droit de faire, et dans quel schema les objets sont ranges.

## Line 2 - User vs role (Frame 2)

**Time:** 30.0 - 64.0s
**Delivery:** Distinguer role de droits et utilisateur connectable.

    Dans PostgreSQL, le mot important est role. Un role est une identite de base de donnees: il peut recevoir des droits et posseder des objets. Un user est simplement un role qui a le droit de se connecter. Dans le lab, app_user et analyst_user sont des utilisateurs. view_reader et analyst_role sont plutot des roles de droits reutilisables.

## Line 3 - Privileges: autorisations explicites (Frame 3)

**Time:** 64.0 - 98.0s
**Delivery:** Lire les privileges comme une pile d'autorisations.

    Un privilege est une autorisation explicite. CONNECT permet d'entrer dans la base. USAGE permet d'utiliser un schema. SELECT lit une table ou une vue. INSERT ajoute des lignes. CREATE permet de creer des objets dans un espace donne. Si le droit manque, PostgreSQL refuse. Ce refus est normal: c'est le systeme de securite qui travaille.

## Line 4 - Least privilege (Frame 4)

**Time:** 98.0 - 130.0s
**Delivery:** Insister sur la regle de conception.

    La regle centrale est le principe du moindre privilege. On ne donne pas tous les droits par confort. Une application n'a pas besoin d'etre superuser. Un lecteur de vues n'a pas besoin de modifier les tables. Un analyste peut avoir de la lecture large sans recevoir le pouvoir de detruire les objets. Chaque droit doit correspondre a un vrai besoin.

## Line 5 - Schemas: dossiers logiques et frontieres (Frame 5)

**Time:** 130.0 - 166.0s
**Delivery:** Expliquer schema, namespace, frontiere, puis USAGE versus CREATE.

    Un schema est un dossier logique dans une base PostgreSQL. Il evite les conflits de noms et il sert aussi de frontiere de securite. Dans le lab, app_data separe les objets de l'application du schema public. Attention: avoir USAGE sur un schema permet de le traverser pour atteindre des objets autorises. Ce n'est pas la meme chose que CREATE, qui permet d'y creer de nouveaux objets.

## Line 6 - Tables et sequences (Frame 6)

**Time:** 166.0 - 198.0s
**Delivery:** Garder l'explication conceptuelle, sans correction d'exercice.

    Les droits ne s'arretent pas a la table. Quand une colonne utilise SERIAL, PostgreSQL s'appuie sur une sequence pour produire la prochaine valeur. Donc un utilisateur peut avoir INSERT sur une table, puis echouer parce qu'il n'a pas USAGE sur la sequence associee. C'est une erreur tres utile: elle montre que table et sequence sont deux objets differents.

## Line 7 - Row-Level Security (Frame 7)

**Time:** 198.0 - 232.0s
**Delivery:** Contraster privilege table et filtre de lignes.

    Row-Level Security ajoute une couche plus fine. Les privileges normaux repondent a la question: ai-je le droit d'utiliser cette table? RLS repond ensuite: quelles lignes ai-je le droit de voir ou de modifier? Le modele du lab est simple: dans app_data.tasks, chaque utilisateur ne voit que les lignes ou assigned_to correspond a current_user.

## Line 8 - Verifier sa comprehension dans le lab (Frame 8)

**Time:** 232.0 - 260.0s
**Delivery:** Terminer sur les habitudes de verification.

    Pendant le lab, ne verifiez pas seulement comme postgres. Testez avec le vrai utilisateur limite: app_user ou analyst_user. Lisez les erreurs de permission, elles indiquent souvent le niveau manquant: base, schema, table ou sequence. Utilisez les requetes de verification sur pg_roles, pg_auth_members, information_schema et pg_policies. Et gardez le nettoyage pour la fin, quand vous avez compris ce que chaque droit change.
