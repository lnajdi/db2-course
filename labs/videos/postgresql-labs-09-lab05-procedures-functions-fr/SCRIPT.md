---
title: "Lab 05 - Procedures et fonctions"
language: fr
duration: 260
sources:
  - ../Lab05-procedures-functions/README.md
  - ../Lab05-procedures-functions/Lab-05-procedures-functions.sql
music: none
narration: external teacher WAV pending
---

# Script voix off

## 01

Dans ce Lab 05, on change de niveau. Le bloc `DO $$` servait a s'entrainer avec PL/pgSQL. Maintenant, l'objectif est d'ecrire de la logique que la base peut reutiliser: des fonctions et des procedures. Avant de commencer, il faut Pagila chargee, les bases PL/pgSQL revues, et un editeur SQL pret a executer de petits tests.

## 02

Le modele mental le plus important est simple. Une fonction repond a une question et retourne une valeur ou un ensemble de lignes. On l'appelle avec `SELECT`. Une procedure execute une action: elle peut modifier des donnees, verifier des conditions, et signaler ce qui s'est passe. On l'appelle avec `CALL`.

## 03

Une fonction PostgreSQL a toujours une structure reconnaissable. On declare son nom et ses parametres. On annonce le type retourne avec `RETURNS`. On peut declarer des variables. Puis le bloc `BEGIN ... END` contient la logique, et la fonction finit par retourner un resultat avec `RETURN`.

## 04

La premiere partie du lab travaille les fonctions scalaires. Pensez: entree, calcul, sortie. Convertir une temperature, formater une duree de film, calculer des jours de location, ou estimer des frais de retard: chaque exercice doit produire une seule valeur claire, testable avec un `SELECT`.

## 05

Ensuite, les fonctions interrogent Pagila. Ici, la difficulte n'est pas seulement PL/pgSQL: il faut d'abord ecrire la bonne requete. Testez la requete seule, puis rangez son resultat dans une variable avec `SELECT INTO`. Pour les sommes et moyennes, pensez a `COALESCE`, afin de ne pas transformer l'absence de lignes en resultat inutilisable.

## 06

Certaines fonctions ne retournent pas une seule valeur, mais une table. C'est le role de `RETURNS TABLE` et de `RETURN QUERY`. Dans ce lab, cela sert a produire des listes: meilleurs clients, films par categorie et classification, historique de location d'un client. La fonction devient alors une vue parametree que l'on peut interroger.

## 07

Les fonctions de validation encapsulent des regles metier. Une adresse email a-t-elle la bonne forme ? Un tarif de location est-il acceptable ? Un film est-il disponible dans l'inventaire ? Le resultat est souvent un booleen. Testez aussi les cas mauvais: `NULL`, valeur vide, valeur negative, identifiant absent.

## 08

Les procedures demandent plus de prudence, parce qu'elles changent l'etat de la base. Mettre a jour l'email d'un client, changer le tarif d'un film, ou desactiver un compte: on verifie avant, on appelle la procedure, puis on verifie apres. Les messages `RAISE NOTICE` aident a observer. Les `RAISE EXCEPTION` doivent bloquer les entrees invalides.

## 09

Pour reussir le lab, avancez dans cet ordre. Creez les fonctions d'aide avant les fonctions qui les utilisent. Testez chaque fonction avec les appels fournis. Pour les procedures, capturez l'etat avant et apres. Essayez volontairement de mauvais inputs. Gardez des commentaires avec les sorties observees, et ne lancez le nettoyage qu'a la toute fin.
