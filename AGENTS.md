# AGENTS Operating Contract

This file is the single source of truth for how agents work in this workspace.
No `README.md` is required.

## 1) Scope
- Workspace root: `/Users/yuxiangw/Insync/2024_Monash-L/2026-02_Critical-Raw-Materials-Flagship`
- Topics currently in scope:
  - `topic01_copper`
  - `topic02_iron-steel`
  - `topic03_alumina-aluminium`
- Cross-topic synthesis folder:
  - `landscape-briefing`

## 2) Folder Contract
Each topic folder must follow this structure:

```text
topicXX_<name>/
  WORKING_NOTE.md
  WRITEUP.qmd
  WRITEUP.pdf
  refs/
  subtopics/
    *.qmd
  meta/
    sources.csv
```

Topic-specific metadata files are stored in `meta/` (for example crosswalks, audits, notes, registers).

## 3) File Role Contract
- `WORKING_NOTE.md`
  - Operational control plane.
  - Queue, uncertainties, source-log process notes, next actions, daily log.
- `WRITEUP.qmd`
  - Canonical publishable source for the topic report.
  - Distilled evidence-backed synthesis and implications.
- `WRITEUP.pdf`
  - Rendered distribution artifact generated from `WRITEUP.qmd`.
  - Must be regenerated whenever `WRITEUP.qmd` changes for delivery.
- `subtopics/*.qmd`
  - Module source-of-truth for published content.
  - Edit modules first, then synchronize `WRITEUP.qmd`.
- `refs/`
  - External source corpus (PDFs and reference files used for analysis).
- `meta/sources.csv`
  - Source index for the topic.

## 4) Naming Rules (Strict)
- Use `WORKING_NOTE.md` and `WRITEUP.qmd` only.
- Do not use aliases:
  - `working-note.md` (deprecated)
  - `deep-dive.md` (deprecated)
- Keep module numbering ordered:
  - `00_...`, `01_...`, ..., `90_...`
- Keep topic section order in `WRITEUP.qmd`:
  - `## T1` -> `## T2` -> `## T3` -> `## T4` -> `## T5` -> `## T6`
- Use heading hierarchy correctly:
  - `## T4` then `### T4.x` (never `## T4.x` under `## T4`).

## 5) Update Order (Mandatory)
For topic content updates:
1. Edit `subtopics/*.qmd` first.
2. Sync corresponding sections into `WRITEUP.qmd`.
3. Regenerate/update `WRITEUP.pdf` from current `WRITEUP.qmd` when output is needed.
   - Standard command: `quarto render` (auto-syncs topic PDFs via `scripts/sync_writeup_pdfs.sh`).
4. Update `meta/*` artifacts (for example `sources.csv`, audit files, crosswalks).
5. Run quality checks before finalizing.

## 6) Path and Reference Rules
- Use current workspace paths only.
- Do not introduce stale references to removed roots (for example `Literature-Review/`).
- Keep paths repo-relative where possible (for example `topic01_copper/refs/...`).
- Historical migration artifacts inside `landscape-briefing/*.csv` may retain old paths and should not be rewritten unless explicitly requested.

## 7) Metadata Schema Rules
- `meta/sources.csv` required header:
  - `source_key,title,year,type,path,status,subtopic,notes`
- If a topic uses quantitative audit files, keep them in `meta/` and ensure file-path fields point to current topic paths.

## 8) Quality Gates (Run Before Closing Work)
Run these checks from workspace root:

```bash
# 1) Deprecated filenames must not exist
find topic02_iron-steel topic03_alumina-aluminium -maxdepth 1 -type f \( -name 'deep-dive.md' -o -name 'working-note.md' \)

# 2) Topic sequence in copper writeup
rg -n '^## T[1-6]\.' topic01_copper/WRITEUP.qmd

# 3) No stale root references in active topic docs
rg -n 'Literature-Review/' topic01_copper/WORKING_NOTE.md topic01_copper/WRITEUP.qmd topic01_copper/subtopics/*.qmd topic01_copper/meta/*.csv

# 4) Basic placeholder scan
rg -n 'TBD|CITATION NEEDED|to be added' topic01_copper topic02_iron-steel topic03_alumina-aluminium
```

If a check fails, fix it before concluding the task.

## 9) Hygiene
- Keep `.DS_Store` ignored and out of content folders.
- Avoid duplicate copies across topic root vs `refs/` vs `subtopics/`.
- Keep exactly one canonical `WRITEUP.pdf` at topic root and keep it in sync with `WRITEUP.qmd`.

## 10) Change Discipline
- Prefer small, reversible edits.
- Preserve evidence-bearing content when restructuring.
- If cleanup removes files, ensure information is retained in canonical locations first.
