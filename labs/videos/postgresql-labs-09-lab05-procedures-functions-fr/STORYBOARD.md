---
title: "Lab 05 - Procedures et fonctions"
duration: 260
format: 1920x1080
language: fr
music: none
captions: external later
sources:
  - ../Lab05-procedures-functions/README.md
  - ../Lab05-procedures-functions/Lab-05-procedures-functions.sql
---

# Storyboard

## Video direction

Warm PostgreSQL lab editorial style: cream canvas, Atlantic blue concept labels, pine green validation cues, amber caution on state-changing procedures, dark SQL panels. All critical content stays above `y=880`; the lower 200 px are reserved for later embedded French captions. This is an introduction and roadmap, not a correction.

## Frame 01 - Pourquoi des fonctions et procedures ?

- Time: 0-28s
- Purpose: Reframe the lab as the move from temporary `DO $$` blocks to reusable database logic.
- Visual: Title, prerequisite checklist, and a path from "bloc temporaire" to "logique reusable".
- SQL/table anchors: `DO $$`, `CREATE OR REPLACE FUNCTION`, `CREATE OR REPLACE PROCEDURE`, `customer`, `rental`, `payment`, `film`, `inventory`.

## Frame 02 - Fonction vs procedure

- Time: 28-58s
- Purpose: Establish the mental split: a function returns data; a procedure performs actions.
- Visual: Two-column comparison with `SELECT` on the function side and `CALL` on the procedure side.
- SQL anchors: `SELECT function_name(...)`, `CALL`.

## Frame 03 - Anatomie d'une fonction

- Time: 58-87s
- Purpose: Show the minimal function skeleton without solving any exercise.
- Visual: Annotated SQL panel with parameter, `RETURNS`, optional `DECLARE`, `BEGIN ... END`, `RETURN`, `LANGUAGE plpgsql`.
- SQL anchors: `CREATE OR REPLACE FUNCTION`, `RETURNS`, `RETURN`.

## Frame 04 - Fonctions scalaires

- Time: 87-116s
- Purpose: Roadmap Part 1: one input, a calculation, one returned value.
- Visual: Input-calculation-return diagram and four exercise families: temperature, duration formatting, rental days, late fees.
- SQL anchors: `RETURN`, `SELECT function_name(...)`.

## Frame 05 - Fonctions qui interrogent Pagila

- Time: 116-145s
- Purpose: Roadmap Part 2: query the database, store a value, then return it.
- Visual: Tables flowing into one variable, with `SELECT INTO` and `COALESCE` as anchor ideas.
- Table anchors: `customer`, `rental`, `payment`, `film`, `inventory`.

## Frame 06 - Fonctions qui retournent des tables

- Time: 145-174s
- Purpose: Explain `RETURNS TABLE` and `RETURN QUERY`.
- Visual: A function box outputting multiple rows; short topic cards for top customers, films by category/rating, customer rental history.
- Table anchors: `category`, `film_category`, `customer`, `rental`.

## Frame 07 - Validation functions

- Time: 174-204s
- Purpose: Present validation as reusable business rules.
- Visual: Three rule cards: email, rental rate, film availability, with TRUE/FALSE outcomes and NULL/invalid input warnings.
- SQL/table anchors: `RETURNS BOOLEAN`, `film`, `inventory`.

## Frame 08 - Procedures: modifier avec prudence

- Time: 204-234s
- Purpose: Explain state-changing procedures and why testing must be careful.
- Visual: Amber caution layout with before/after checks, `CALL`, `UPDATE`, `RAISE NOTICE`, `RAISE EXCEPTION`.
- SQL/table anchors: `CREATE OR REPLACE PROCEDURE`, `CALL`, `RAISE NOTICE`, `RAISE EXCEPTION`, `customer`, `film`.

## Frame 09 - Methode pour reussir le lab

- Time: 234-260s
- Purpose: End with a lab method checklist.
- Visual: Five-step checklist: helper functions first, test each call, verify before/after, validate bad inputs, keep observed-output comments, cleanup only at end.
- SQL anchors: `SELECT`, `CALL`, `RAISE NOTICE`.
