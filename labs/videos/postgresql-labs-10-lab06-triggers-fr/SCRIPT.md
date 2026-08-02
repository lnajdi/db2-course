---
title: "Lab 06 - Declencheurs"
language: fr
duration: 260
sources:
  - ../lab06-triggers/README.md
  - ../lab06-triggers/lab06-triggers.sql
music: none
narration: external teacher WAV pending
---

# Script voix off

## 01

Dans ce Lab 06, on aborde les declencheurs. L'idee est simple: la base peut reagir automatiquement quand une donnee change. Vous faites un `INSERT`, un `UPDATE`, ou un `DELETE`; un petit robot cote PostgreSQL se reveille et applique une regle. Avant de commencer, verifiez que Pagila est chargee, que les fonctions PL/pgSQL sont comprises, et que vos tests restent faciles a annuler.

## 02

PostgreSQL separe toujours un declencheur en deux morceaux. D'abord, une fonction trigger decrit quoi faire. Elle retourne le type `TRIGGER`. Ensuite, `CREATE TRIGGER` indique quand lancer cette fonction: sur quelle table, pour quel evenement, avec quel timing, et a quel niveau.

## 03

Le timing change l'intention. Un trigger `BEFORE` s'execute avant l'ecriture: il sert a valider, nettoyer, normaliser, ou bloquer avec `RETURN NULL` ou une exception. Un trigger `AFTER` s'execute apres l'ecriture: il sert surtout a auditer, journaliser, ou declencher un effet secondaire.

## 04

L'evenement dit ce qui vient de se passer. Sur `INSERT`, PostgreSQL vous donne la ligne proposee dans `NEW`. Sur `DELETE`, il n'y a plus de nouvelle ligne: on travaille avec `OLD`. Sur `UPDATE`, les deux images existent: l'ancienne ligne dans `OLD`, la nouvelle dans `NEW`.

## 05

Le niveau decide combien de fois le trigger part. `FOR EACH STATEMENT` se declenche une seule fois pour toute la commande SQL, meme si elle touche plusieurs lignes. `FOR EACH ROW` se declenche une fois par ligne modifiee. Pour un audit ligne par ligne, c'est souvent le niveau row. Pour une verification globale, statement peut suffire.

## 06

Trois noms reviennent tout le temps: `NEW`, `OLD`, et `TG_OP`. `NEW` contient les valeurs qui arrivent. `OLD` contient les valeurs d'avant. `TG_OP` indique l'operation: insertion, modification, ou suppression. L'erreur classique est d'utiliser `NEW` dans un DELETE, ou `OLD` dans un INSERT.

## 07

Le lab vous fait pratiquer deux grands usages: audit et validation. Cote audit, on suit les changements de salaire et les changements d'email client, avec `employee`, `employee_salary_audit`, `customer`, et `customer_email_audit`. Cote validation, on bloque les salaires impossibles, on nettoie les donnees client, et on automatise certains timestamps.

## 08

Pour tester sans casser les donnees, travaillez dans une transaction. Lancez `BEGIN`, faites une modification controlee, observez l'audit ou les messages `RAISE NOTICE`, puis terminez avec `ROLLBACK`. Quand une entree doit etre refusee, `RAISE EXCEPTION` doit bloquer proprement l'operation.

## 09

La methode: creez la fonction d'abord, puis le trigger. Testez une operation a la fois: insertion, modification, suppression. Verifiez que le trigger existe et qu'il est actif. Surveillez les boucles recursives et gardez la logique courte. Le nettoyage ne vient qu'a la fin, quand vous avez capture les resultats importants.
