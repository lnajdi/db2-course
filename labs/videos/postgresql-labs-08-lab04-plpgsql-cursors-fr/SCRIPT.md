# SCRIPT - Lab 04 PL/pgSQL et curseurs

**Voice:** `Audio-Postgresql-labs-08-lab04-plpgsql-cursors-fr.wav` - voix francaise de l'enseignant, a fournir
**Voice settings:** debit naturel, articulation nette, pauses pedagogiques
**Voice direction:** Pedagogique, calme et directe. L'episode introduit les concepts et la methode du lab; ne pas donner une correction.
**Sources:** `../lab04-intro-plpgsql-cursors/README.md` et `../lab04-intro-plpgsql-cursors/Lab-04-intro-plpgsql-cursors.sql`

---

## Line 1 - Pourquoi PL/pgSQL maintenant ? (Frame 1)

**Time:** 0.0 - 28.0s
**Delivery:** Poser le changement: SQL reste central, PL/pgSQL ajoute une logique procedurale.

    Dans les labs precedents, vous avez surtout ecrit des requetes SQL: lire, filtrer, joindre, mesurer, proteger. Avec le Lab 04, on ajoute une couche: ecrire une petite logique procedurale directement dans PostgreSQL. L'objectif n'est pas de remplacer SQL. L'objectif est de savoir quand une suite d'instructions, de variables et de tests aide a piloter un traitement.

## Line 2 - Anatomie d'un DO block (Frame 2)

**Time:** 28.0 - 58.0s
**Delivery:** Expliquer chaque zone sans surcharge syntaxique.

    Le premier objet mental est le DO block. DO dit a PostgreSQL: execute ce morceau de PL/pgSQL maintenant, sans creer de fonction permanente. Le bloc commence avec le delimitateur dollar-dollar. La zone DECLARE est optionnelle et sert aux variables. La zone BEGIN, END contient les instructions. Et RAISE NOTICE devient votre premier outil de debogage.

## Line 3 - Variables et type safety (Frame 3)

**Time:** 58.0 - 86.0s
**Delivery:** Faire comprendre pourquoi `%TYPE` est une bonne habitude.

    Dans PL/pgSQL, une variable a un type. Vous pouvez choisir un type fixe, comme integer ou varchar. Mais le lab vous fait aussi utiliser pourcent TYPE. Quand vous declarez une variable comme customer dot email pourcent TYPE, elle suit le type de la colonne email. Si le schema evolue, le code reste plus coherent.

## Line 4 - SELECT INTO et conditions (Frame 4)

**Time:** 86.0 - 115.0s
**Delivery:** Relier requete, variables, puis categorie.

    SELECT INTO est le pont entre une requete SQL et des variables PL/pgSQL. La requete calcule ou lit des valeurs, puis INTO les range dans les variables. Ensuite, vous pouvez tester ces valeurs avec IF, ELSIF et ELSE. Par exemple, un tarif de location peut devenir une categorie: budget, standard ou premium.

## Line 5 - Boucles: FOR, WHILE, RECORD (Frame 5)

**Time:** 115.0 - 145.0s
**Delivery:** Montrer la progression pedagogique du lab.

    Le lab avance ensuite vers les boucles. Une boucle FOR sur des nombres sert a comprendre la syntaxe. Une boucle FOR sur une requete parcourt des lignes. RECORD est un conteneur flexible: il prend la forme de la ligne retournee. Vous le verrez avec category, payment et customer. Le point important est de garder un compteur, un total, ou une decision claire.

## Line 6 - Cursors: quand et pourquoi ? (Frame 6)

**Time:** 145.0 - 176.0s
**Delivery:** Insister sur la regle SQL d'abord.

    Un curseur est une facon de traiter un resultat ligne par ligne. Imaginez un pointeur qui avance dans un ensemble de lignes. C'est utile quand chaque ligne peut demander une action differente, quand vous gardez un etat entre les lignes, ou quand vous voulez sortir tot. Mais la regle reste simple: essayez SQL d'abord. Un SUM, un UPDATE WHERE ou un GROUP BY est souvent meilleur qu'une boucle.

## Line 7 - Trois formes de curseurs (Frame 7)

**Time:** 176.0 - 206.0s
**Delivery:** Comparer sans presenter le curseur manuel comme le style normal.

    Le lab montre trois formes. La plus simple est FOR rec IN SELECT: pas de curseur a nommer, PostgreSQL gere l'iteration. Ensuite, le curseur nomme avec CURSOR FOR rend la requete reutilisable, notamment avec des parametres. Enfin, la version manuelle OPEN, FETCH, EXIT WHEN NOT FOUND, CLOSE montre le cycle complet. Elle est importante pour apprendre, mais ce n'est pas le style par defaut.

## Line 8 - Parametres, curseurs imbriques, exceptions (Frame 8)

**Time:** 206.0 - 234.0s
**Delivery:** Donner un apercu des concepts avances sans solution.

    Dans la deuxieme moitie, le lab ajoute des curseurs parametres, des curseurs imbriques, une sortie anticipee et des messages de progression. Puis il introduit SELECT INTO STRICT. Avec STRICT, PostgreSQL doit trouver exactement une ligne. Zero ligne declenche NO DATA FOUND. Plusieurs lignes declenchent TOO MANY ROWS. Ces exceptions vous obligent a penser aux cas limites.

## Line 9 - Methode pour reussir le lab (Frame 9)

**Time:** 234.0 - 260.0s
**Delivery:** Terminer en checklist d'execution.

    Pour reussir ce lab, avancez bloc par bloc. Testez la requete SQL seule avant de l'integrer dans PL/pgSQL. Ajoutez LIMIT pendant les essais. Utilisez RAISE NOTICE pour voir les valeurs et la progression. Lisez les erreurs: il manque souvent un point-virgule, un END IF, un END LOOP ou une variable. Et gardez en commentaire ce que vous avez observe.
