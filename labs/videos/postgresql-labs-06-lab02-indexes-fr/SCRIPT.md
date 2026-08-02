# SCRIPT - Lab 02 Indexes

**Voice:** `Audio-Postgresql-labs-06-lab02-indexes-fr.wav` - voix francaise de l'enseignant, a fournir
**Voice settings:** debit original conserve, articulation nette, pauses pedagogiques
**Voice direction:** Pedagogique, calme et directe. L'episode prepare le lab sans le corriger; garder un ton de cadrage methodologique.

---

## Line 1 - Objectif du Lab 02 (Frame 1)

**Time:** 0.0 - 26.0s
**Delivery:** Poser le cadre: introduction, pas correction.

    Dans cet episode, nous ouvrons le Lab 02: Indexes. Nous n'allons pas corriger les exercices. Le but est de comprendre la methode: demarrer PostgreSQL, verifier Pagila, lancer une requete, mesurer son plan, puis seulement creer un index.

## Line 2 - Roadmap du lab (Frame 2)

**Time:** 26.0 - 60.0s
**Delivery:** Lire la carte comme une sequence de travail.

    Le parcours du lab est simple. D'abord, on inspecte les tables Pagila. Ensuite, on observe les index deja presents. Puis on lance des requetes lentes avec EXPLAIN ANALYZE, on cree des index cibles, on compare les plans, on optimise une requete de reporting, et on garde le nettoyage pour la fin.

## Line 3 - Pourquoi mesurer avant d'indexer (Frame 3)

**Time:** 60.0 - 92.0s
**Delivery:** Insister sur le compromis des index.

    Un index n'est pas une decoration qu'on ajoute partout. Il accelere certaines lectures, mais il coute de l'espace et du travail pendant les ecritures. Dans ce lab, la discipline importante est donc: mesurer d'abord, noter le temps, lire le plan, puis choisir l'index qui correspond vraiment a la requete.

## Line 4 - Seq Scan vs Index Scan (Frame 4)

**Time:** 92.0 - 124.0s
**Delivery:** Contraster parcours complet et acces cible.

    Quand PostgreSQL affiche Seq Scan, il parcourt la table ligne par ligne. Pour une recherche comme film point title egal ACADEMY DINOSAUR, c'est volontairement tres visible dans le lab. Avec un Index Scan, PostgreSQL utilise une structure triee pour aller beaucoup plus directement vers les lignes candidates.

## Line 5 - Creer un index B-tree simple (Frame 5)

**Time:** 124.0 - 154.0s
**Delivery:** Garder l'extrait court et rappeler la comparaison.

    Le premier index important est un B-tree simple sur le titre du film. L'extrait a retenir est CREATE INDEX idx_film_title ON film title. Apres creation, on relance exactement la meme requete avec EXPLAIN ANALYZE. Ce qui compte, c'est la comparaison, pas seulement la creation de l'objet.

## Line 6 - Lire EXPLAIN ANALYZE (Frame 6)

**Time:** 154.0 - 190.0s
**Delivery:** Donner des reperes de lecture, sans entrer dans tous les details du planificateur.

    Pour lire EXPLAIN ANALYZE au niveau debutant, cherchez quelques reperes. Le type de noeud: Seq Scan, Index Scan, Hash Join ou Sort. Le actual time, qui donne le temps reel. Le nombre de lignes gardees ou retirees par le filtre. Avec BUFFERS, regardez aussi les pages lues ou deja en memoire. Et tout en bas, notez Execution Time.

## Line 7 - Indexes avances du lab (Frame 7)

**Time:** 190.0 - 224.0s
**Delivery:** Presenter trois familles sans developper la correction.

    Le lab va ensuite plus loin. Un index fonctionnel peut correspondre a une condition comme UPPER name. Un index sur rental_date aide les tris, les filtres et les regroupements par date. Et un index composite, par exemple sur first_name puis last_name, se lit de gauche a droite: l'ordre des colonnes fait partie de la strategie.

## Line 8 - Methode de travail et suite (Frame 8)

**Time:** 224.0 - 250.0s
**Delivery:** Terminer sur la discipline de travail.

    Pour travailler proprement, executez un bloc a la fois. Gardez les plans avant et apres, notez les temps, et expliquez pourquoi l'index aide ou n'aide pas. Ne gardez pas les index inutiles par habitude. A la fin seulement, utilisez les DROP INDEX IF EXISTS pour nettoyer votre base de test.
