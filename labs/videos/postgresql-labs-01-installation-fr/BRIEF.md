---
workflow: faceless-explainer
flow: automation
storyboard: yes
message: "Installer correctement PostgreSQL Server, pgAdmin 4 et les outils en ligne de commande sous Windows pour commencer les TP"
destination: youtube
aspect: 1920x1080
language: fr
audience: "débutants utilisant Windows 10 ou Windows 11"
length: 211s
angle: how-to
narration: external-final
captions: embedded-fr
music: none
---

## Intent

Créer l’épisode 01/08 d’une série d’accompagnement PostgreSQL pour des étudiants débutants. La vidéo doit leur permettre d’installer les composants nécessaires sous Windows sans hésiter sur les écrans de l’installateur. Le ton est calme, précis et rassurant; chaque action associe une consigne, une justification brève et un état visuel attendu.

## Assets

- `../../../tokens/` — source de l’identité visuelle à convertir en variables sémantiques HyperFrames.
- `../../../postgresql-windows-student-guide.qmd` — guide pédagogique local de référence.

## Customizations

- Reproduction HTML simplifiée, sans capture réelle, de l’installateur Windows EDB.
- Six à sept fenêtres reconnaissables, avec agrandissement des contrôles importants.
- Marqueurs « Pausez ici » avant le téléchargement et la saisie du mot de passe.
- Sous-titres français incrustés dans une bande inférieure réservée.
- Sons d’interface discrets; aucune musique.
- Voix française finale fournie par l’enseignant, conservant des pauses pédagogiques.
- Entrées calmes et fonctionnelles; transitions Atlantic blue ou transformations de fenêtre partagée.

## Notes

- Employer Literata pour les titres, Instrument Sans pour les explications et Geist Mono pour les chemins, ports et commandes.
- Aucun hexadécimal brut dans les composants; toutes les couleurs passent par des variables sémantiques.
- Pine green uniquement pour les confirmations; Walnut de façon ponctuelle; danger et warning pour les alertes.
- Ne graver aucun numéro majeur PostgreSQL dans les scènes: dire « dernière version x86-64 prise en charge ».
- L’épisode s’arrête après l’installation; la première connexion appartient à l’épisode 2.
- Aucun logo, média photographique ni publication YouTube automatique.
- La piste finale est `Audio-Postgresql-labs-01-installation-fr.wav` (3 min 31 s); les scènes et sous-titres suivent cette durée.
- Sources officielles: https://www.postgresql.org/download/windows/ et https://www.enterprisedb.com/docs/supported-open-source/postgresql/installing/windows/
