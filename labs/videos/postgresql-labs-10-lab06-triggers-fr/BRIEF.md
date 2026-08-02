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
project: postgresql-labs-10-lab06-triggers-fr
style_preset: PostgreSQL labs editorial frame
---

# PostgreSQL Labs 10 - Lab 06 Declencheurs

Create a French faceless explainer introducing the Lab 06 triggers assignment. The video is a concept and roadmap, not a correction and not a solution walkthrough.

## Sources

- `../lab06-triggers/README.md`
- `../lab06-triggers/lab06-triggers.sql`

Do not use `../lab06-triggers/solutions.sql` as video content. The README says "Lab 10" and the SQL footer says "END OF LAB 10", but the folder and SQL filename identify this as Lab 06. The visible episode label must therefore use Lab 06.

## Visible Identity

- Kicker: `10 - Lab 06`
- Title: `Lab 06 - Declencheurs`

## Editorial Guardrails

- Explain beginner mental models before lab sections: automatic database reactions, the two-part PostgreSQL model, timing, event, level, `NEW`, `OLD`, `TG_OP`, `RETURN NEW`, validation, audit, debugging, and performance caution.
- Show only short SQL anchors: `CREATE OR REPLACE FUNCTION`, `RETURNS TRIGGER`, `RETURN NEW`, `RETURN OLD`, `RETURN NULL`, `CREATE TRIGGER`, `BEFORE`, `AFTER`, `INSERT`, `UPDATE`, `DELETE`, `FOR EACH ROW`, `FOR EACH STATEMENT`, `EXECUTE FUNCTION`, `RAISE NOTICE`, `RAISE EXCEPTION`, `BEGIN`, `ROLLBACK`.
- Avoid full trigger solutions, TODO answers, sample implementation blocks from the README, cleanup blocks, long audit code, and commented "SOLUTION FOR EXERCISE" sections.
- Preserve visual continuity with episodes 03-09: warm editorial canvas, Literata titles, Instrument Sans body, Geist Mono for SQL.
- Reserve `y=880-1080` for future embedded French captions.

## Delivery State

This pass creates project artifacts and an assembled `index.html`. No MP4 render is requested because the final teacher narration and captions are pending.
