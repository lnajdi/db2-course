# SCRIPT - Lab 01 Views et vues matérialisées

**Voice:** `Audio-Postgresql-labs-05-lab01-vues-fr.wav` - voix française de l'enseignant, à fournir
**Voice settings:** débit original conservé, articulation nette, pauses pédagogiques
**Voice direction:** Pédagogique, calme et directe. L'épisode prépare le lab sans le corriger; garder un ton de cadrage conceptuel.

---

## Line 1 - Objectif du Lab 01 (Frame 1)

**Time:** 0.0 - 24.0s
**Delivery:** Clarifier que c'est une introduction, pas une correction.

    Dans cet épisode, nous ouvrons le Lab 01 sur les vues PostgreSQL. Nous n'allons pas encore corriger les exercices. L'objectif est de comprendre la carte du lab, puis la différence entre une vue normale et une vue matérialisée.

## Line 2 - Roadmap du lab (Frame 2)

**Time:** 24.0 - 58.0s
**Delivery:** Lire les familles d'exercices comme une carte de travail.

    Le lab avance en plusieurs familles: vues simples, vues modifiables, sécurité avec WITH CHECK OPTION, vues multi-tables, vues matérialisées, puis refresh et comparaison de performance. Le livrable final sera un fichier solutions.sql.

## Line 3 - Une vue, c'est quoi ? (Frame 3)

**Time:** 58.0 - 90.0s
**Delivery:** Insister sur requête enregistrée et table virtuelle.

    Une vue normale, c'est une requête enregistrée sous un nom. On peut ensuite l'interroger comme une table virtuelle. Important: la vue normale ne stocke pas les lignes; PostgreSQL recalcule le résultat quand on la lit.

## Line 4 - Pourquoi créer une vue ? (Frame 4)

**Time:** 90.0 - 124.0s
**Delivery:** Relier les bénéfices aux exemples du lab.

    Pourquoi créer une vue? Pour simplifier une requête longue, pour cacher certaines colonnes sensibles, ou pour donner un nom stable à une présentation des données. Par exemple, customer_info peut cacher la complexité des jointures d'adresse.

## Line 5 - Vue classique: modèle mental (Frame 5)

**Time:** 124.0 - 154.0s
**Delivery:** Décomposer la chaîne table, select, create view, select sur la vue.

    Le modèle mental est simple: les tables Pagila restent la source. La requête SELECT décrit ce qu'on veut voir. CREATE VIEW donne un nom à cette requête. Ensuite, SELECT étoile FROM customer_info LIMIT cinq lit la vue.

## Line 6 - Vues modifiables et CHECK OPTION (Frame 6)

**Time:** 154.0 - 184.0s
**Delivery:** Présenter la règle générale sans détailler toutes les exceptions PostgreSQL.

    Certaines vues simples peuvent être modifiables, surtout si elles viennent d'une seule table. Une vue avec des jointures ou des agrégats est généralement en lecture seule. WITH CHECK OPTION ajoute une règle: une modification ne doit pas faire disparaître la ligne de la vue.

## Line 7 - Vue matérialisée (Frame 7)

**Time:** 184.0 - 222.0s
**Delivery:** Contraster vitesse, stockage et fraîcheur des données.

    Une vue matérialisée est différente. Elle stocke physiquement le résultat d'une requête, par exemple des statistiques par catégorie dans film_stats. C'est souvent plus rapide pour lire, mais le résultat peut devenir ancien. Il faut le mettre à jour avec REFRESH MATERIALIZED VIEW.

## Line 8 - Comment travailler le lab (Frame 8)

**Time:** 222.0 - 252.0s
**Delivery:** Donner une méthode pratique et finir vers le prochain épisode.

    Pour travailler le lab, ouvrez Lab tiret 01 tiret Views point sql. Exécutez une section à la fois, testez chaque vue, lisez les messages d'erreur, et gardez la partie cleanup pour la fin. Le but n'est pas de copier vite, mais de comprendre ce que chaque vue rend plus simple.
