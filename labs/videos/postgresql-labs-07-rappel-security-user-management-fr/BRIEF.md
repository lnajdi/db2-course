---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Rappeler les concepts PostgreSQL de roles, schemas et securite avant le Lab 03"
destination: youtube
aspect: 1920x1080
language: fr
audience: "debutants PostgreSQL avant lab03-PostgreSQL-Security-UserManagement"
length: 260s
angle: concept-recap
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Creer l'episode 07/08 comme rappel conceptuel avant `lab03-PostgreSQL-Security-UserManagement`. L'episode doit confirmer les notions de base avant le lab: qui se connecte, quels droits sont accordes, ou vivent les objets, et comment verifier une configuration de securite. Ce n'est pas une correction et ce n'est pas une roadmap detaillee des exercices.

## Assets

- Aucun media reel requis.
- Sources pedagogiques locales:
  - `../lab03-PostgreSQL-Security-UserManagement/README.md`
  - `../lab03-PostgreSQL-Security-UserManagement/lab03-PostgreSQL-Security-UserManagement.sql`
- La voix finale sera fournie plus tard par l'enseignant.
- Les sous-titres francais seront generes apres alignement sur la piste WAV finale.

## Customizations

- Titre visible: **Rappel - Roles, Schemas et Securite PostgreSQL**.
- Continuite visuelle avec les episodes 03-06: canvas chaud, titres Literata, texte Instrument Sans, code et noms SQL en Geist Mono.
- Reproductions HTML inventees uniquement: aucun logo, aucune capture reelle.
- Montrer seulement des fragments SQL courts: `CREATE USER`, `CREATE ROLE`, `GRANT`, `CREATE SCHEMA`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`.
- Ne pas afficher de mots de passe, de politiques completes, de correction complete, ni de script de nettoyage.
- Bande inferieure de 200 px reservee aux sous-titres: aucun contenu critique sous `y=880`.
- Aucune musique, aucune publication automatique.

## Notes

- Concepts a citer: user, role, privilege, least privilege, schema, table access, sequence access, Row-Level Security, verification.
- Noms SQL visibles a conserver: `app_user`, `analyst_user`, `view_reader`, `analyst_role`, `app_data`, `tasks`, `user_tasks_policy`.
- Le modele mental RLS autorise: `assigned_to = current_user`.
