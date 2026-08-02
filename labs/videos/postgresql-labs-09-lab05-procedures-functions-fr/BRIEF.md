---
workflow: faceless-explainer
flow: autonomous
storyboard: no
format: 1920x1080
destination: YouTube
duration: 260
language: fr
captions: embedded later
music: none
narration: external final teacher WAV pending
project: postgresql-labs-09-lab05-procedures-functions-fr
style_preset: PostgreSQL labs editorial frame
---

# PostgreSQL Labs 09 - Lab 05 Procedures et fonctions

Create a French faceless explainer introducing the Lab 05 procedures and functions assignment. The video is a concept and roadmap, not a correction and not a solution walkthrough.

## Sources

- `../Lab05-procedures-functions/README.md`
- `../Lab05-procedures-functions/Lab-05-procedures-functions.sql`

Do not use `solutions.sql` as video content. The README and SQL comments contain stale "Lab 04" labels, but the folder and SQL filename identify this as Lab 05. The visible episode label must therefore use Lab 05.

## Visible Identity

- Kicker: `09 - Lab 05`
- Title: `Lab 05 - Procedures et fonctions`

## Editorial Guardrails

- Explain beginner mental models before lab sections: reusable database logic, functions vs procedures, return values vs side effects, parameters, `RETURNS`, `RETURN`, `RETURNS TABLE`, `RETURN QUERY`, validation, exceptions, and procedure testing.
- Show only short SQL anchors: `CREATE OR REPLACE FUNCTION`, `RETURNS`, `RETURN`, `SELECT function_name(...)`, `RETURNS TABLE`, `RETURN QUERY`, `CREATE OR REPLACE PROCEDURE`, `CALL`, `RAISE NOTICE`, `RAISE EXCEPTION`.
- Avoid filling blanks, complete functions/procedures, cleanup blocks, bonus solutions, long report procedures, and transfer-inventory code.
- Preserve visual continuity with episodes 03-08: warm editorial canvas, Literata titles, Instrument Sans body, Geist Mono for SQL.
- Reserve `y=880-1080` for future embedded captions.

## Delivery State

This pass creates project artifacts and an assembled `index.html`. No MP4 render is requested because the final teacher narration and captions are pending.
