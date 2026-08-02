---
title: "Lab 06 - Declencheurs"
duration: 260
format: 1920x1080
language: fr
music: none
captions: external later
sources:
  - ../lab06-triggers/README.md
  - ../lab06-triggers/lab06-triggers.sql
---

# Storyboard

## Video direction

Warm PostgreSQL lab editorial style: cream canvas, Atlantic blue concept labels, pine green validation cues, amber caution for automatic side effects, dark SQL panels. All critical content stays above `y=880`; the lower 200 px are reserved for later embedded French captions. This is an introduction and roadmap, not a correction.

## Frame 01 - Pourquoi des declencheurs ?

- Time: 0-28s
- Purpose: Reframe triggers as database robots that react automatically when data changes.
- Visual: Title, prerequisite checklist, and a path from SQL change to automatic reaction.
- SQL/table anchors: `INSERT`, `UPDATE`, `DELETE`, `employee`, `customer`, `film`.

## Frame 02 - Deux morceaux: fonction puis trigger

- Time: 28-58s
- Purpose: Explain PostgreSQL's split: the trigger function says what to do; `CREATE TRIGGER` says when to do it.
- Visual: Two connected panels labelled "quoi faire" and "quand le faire".
- SQL anchors: `CREATE OR REPLACE FUNCTION`, `RETURNS TRIGGER`, `CREATE TRIGGER`, `EXECUTE FUNCTION`.

## Frame 03 - Timing: BEFORE vs AFTER

- Time: 58-87s
- Purpose: Contrast validation before the write with audit after the write.
- Visual: Timeline around a database write, with BEFORE on the left and AFTER on the right.
- SQL anchors: `BEFORE`, `AFTER`, `RETURN NEW`, `RETURN NULL`.

## Frame 04 - Event: INSERT, UPDATE, DELETE

- Time: 87-116s
- Purpose: Tie each event to available row images without complete implementation code.
- Visual: Three event cards: INSERT has `NEW`, DELETE has `OLD`, UPDATE has both.
- SQL anchors: `INSERT`, `UPDATE`, `DELETE`, `NEW`, `OLD`.

## Frame 05 - Level: statement vs row

- Time: 116-145s
- Purpose: Explain `FOR EACH STATEMENT` fires once per SQL command, while `FOR EACH ROW` fires once per affected row.
- Visual: One SQL statement affecting one row vs many rows, with trigger count badges.
- SQL anchors: `FOR EACH STATEMENT`, `FOR EACH ROW`.

## Frame 06 - NEW, OLD, TG_OP

- Time: 145-174s
- Purpose: Make special variables explicit and warn against using the wrong one for the event.
- Visual: Variable map and a "common mistake" strip.
- SQL anchors: `NEW`, `OLD`, `TG_OP`, `RETURN NEW`, `RETURN OLD`.

## Frame 07 - Audit et validation

- Time: 174-204s
- Purpose: Roadmap the lab sections: salary audit, customer email audit, salary validation, email validation, customer cleanup, timestamp updates.
- Visual: Six lab-section cards connected to visible tables.
- Table anchors: `employee`, `employee_salary_audit`, `customer`, `customer_email_audit`, `film`.

## Frame 08 - Tester sans casser les donnees

- Time: 204-234s
- Purpose: Explain safe trigger testing inside transactions and observation tools.
- Visual: Transaction checklist with inspect and rollback.
- SQL anchors: `BEGIN`, `UPDATE`, `RAISE NOTICE`, `RAISE EXCEPTION`, `ROLLBACK`.

## Frame 09 - Methode pour reussir le lab

- Time: 234-260s
- Purpose: End with a practical checklist for completing the lab without turning the video into a correction.
- Visual: Five-step checklist: function first, trigger second, one operation at a time, verify trigger exists/enabled, watch recursion and performance, cleanup only at end.
- SQL anchors: `CREATE OR REPLACE FUNCTION`, `CREATE TRIGGER`, `RAISE NOTICE`.
