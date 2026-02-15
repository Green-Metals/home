#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import hashlib
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
TOPICS_DIR = ROOT / "content" / "topics"
BIB_PATH = ROOT / "content" / "references" / "references.bib"
SOURCES_HEADER = ["source_key", "title", "year", "type", "path", "status", "subtopic", "notes"]


@dataclass
class RenameOp:
    topic_dir: Path
    source_key: str
    status: str
    source_type: str
    title: str
    year: str
    old_path: str
    new_path: str
    old_abs: Path
    new_abs: Path
    old_name: str
    new_name: str


@dataclass
class BibEntry:
    entry_type: str
    key: str
    raw: str
    title: str
    year: str


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def normalize_title(s: str) -> str:
    s = s or ""
    s = re.sub(r"[^a-z0-9]+", "", s.lower())
    return s


def topic_dirs(topic_filters: list[str]) -> list[Path]:
    dirs = sorted([p for p in TOPICS_DIR.glob("topic*") if p.is_dir()])
    if not topic_filters:
        return dirs
    allowed = set(topic_filters)
    filtered = [p for p in dirs if p.name in allowed]
    missing = sorted(allowed - {p.name for p in filtered})
    if missing:
        raise RuntimeError(f"Unknown topic filter(s): {', '.join(missing)}")
    return filtered


def read_sources_csv(path: Path) -> tuple[list[dict[str, str]], list[str]]:
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames != SOURCES_HEADER:
            raise RuntimeError(
                f"{path.relative_to(ROOT)} has invalid header: {reader.fieldnames}; expected {SOURCES_HEADER}"
            )
        rows = [dict(row) for row in reader]
    return rows, SOURCES_HEADER


def write_sources_csv(path: Path, rows: list[dict[str, str]], header: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=header, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def is_used_local_source(row: dict[str, str]) -> bool:
    rel = (row.get("path") or "").strip()
    status = (row.get("status") or "").strip().lower()
    if not rel:
        return False
    if status == "unresolved":
        return False
    if rel.startswith(("http://", "https://")):
        return False
    if "/refs-sources/" not in rel:
        return False
    return True


def build_ops_for_topic(topic_dir: Path) -> tuple[list[RenameOp], list[dict[str, str]], list[str]]:
    sources_path = topic_dir / "meta" / "sources.csv"
    rows, header = read_sources_csv(sources_path)
    ops: list[RenameOp] = []
    for row in rows:
        if not is_used_local_source(row):
            continue
        source_key = (row.get("source_key") or "").strip()
        rel = (row.get("path") or "").strip()
        if not source_key:
            raise RuntimeError(f"Missing source_key in {sources_path.relative_to(ROOT)} row with path={rel}")
        old_abs = ROOT / rel
        old_name = old_abs.name
        ext = old_abs.suffix
        if not ext:
            raise RuntimeError(f"Cannot determine extension for {rel}")
        new_name = f"{source_key}{ext}"
        new_abs = old_abs.with_name(new_name)
        new_rel = str(new_abs.relative_to(ROOT))
        ops.append(
            RenameOp(
                topic_dir=topic_dir,
                source_key=source_key,
                status=(row.get("status") or "").strip(),
                source_type=(row.get("type") or "").strip(),
                title=(row.get("title") or "").strip(),
                year=(row.get("year") or "").strip(),
                old_path=rel,
                new_path=new_rel,
                old_abs=old_abs,
                new_abs=new_abs,
                old_name=old_name,
                new_name=new_name,
            )
        )
    return ops, rows, header


def rewrite_text_file(path: Path, replacements: Iterable[tuple[str, str]]) -> bool:
    original = path.read_text(encoding="utf-8")
    updated = original
    for old, new in replacements:
        if old != new:
            updated = updated.replace(old, new)
    if updated != original:
        path.write_text(updated, encoding="utf-8")
        return True
    return False


def find_bib_entries(text: str) -> list[str]:
    entries: list[str] = []
    i = 0
    n = len(text)
    while i < n:
        at = text.find("@", i)
        if at == -1:
            break
        brace = text.find("{", at)
        if brace == -1:
            break
        depth = 0
        j = brace
        while j < n:
            c = text[j]
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    entries.append(text[at : j + 1].strip())
                    i = j + 1
                    break
            j += 1
        else:
            raise RuntimeError("Failed to parse references.bib: unmatched braces")
    return entries


def parse_bib_header(raw: str) -> tuple[str, str]:
    m = re.match(r"@([A-Za-z0-9_:+.-]+)\{([^,]+),", raw)
    if not m:
        raise RuntimeError(f"Invalid BibTeX entry header: {raw[:80]}")
    return m.group(1), m.group(2)


def extract_bib_field(raw: str, field: str) -> str:
    m = re.search(rf"\b{re.escape(field)}\s*=\s*", raw, flags=re.IGNORECASE)
    if not m:
        return ""
    i = m.end()
    n = len(raw)
    while i < n and raw[i].isspace():
        i += 1
    if i >= n:
        return ""
    if raw[i] == "{":
        depth = 0
        start = i + 1
        i += 1
        while i < n:
            if raw[i] == "{":
                depth += 1
            elif raw[i] == "}":
                if depth == 0:
                    return raw[start:i].strip()
                depth -= 1
            i += 1
        return ""
    if raw[i] == '"':
        i += 1
        start = i
        while i < n:
            if raw[i] == '"' and raw[i - 1] != "\\":
                return raw[start:i].strip()
            i += 1
        return ""
    start = i
    while i < n and raw[i] not in ",\n":
        i += 1
    return raw[start:i].strip()


def load_bib_entries(path: Path) -> list[BibEntry]:
    text = path.read_text(encoding="utf-8")
    raws = find_bib_entries(text)
    entries: list[BibEntry] = []
    for raw in raws:
        entry_type, key = parse_bib_header(raw)
        title = extract_bib_field(raw, "title")
        year = extract_bib_field(raw, "year")
        entries.append(BibEntry(entry_type=entry_type, key=key, raw=raw, title=title, year=year))
    return entries


def serialize_bib(entries: list[BibEntry]) -> str:
    return "\n\n".join(e.raw.strip() for e in entries).rstrip() + "\n"


def infer_bib_type(source_type: str, path: str) -> str:
    t = source_type.lower()
    p = path.lower()
    if "article" in t or "peer reviewed" in t:
        return "article"
    if "web" in t or p.endswith(".html"):
        return "webpage"
    return "report"


def format_bib_entry(entry_type: str, key: str, title: str, year: str, file_path: str) -> str:
    lines = [f"@{entry_type}{{{key},"]
    lines.append(f"  title = {{{title or key}}},")
    lines.append("  author = {{Unknown Author}},")
    if year.strip():
        lines.append(f"  year = {{{year.strip()}}},")
    lines.append(f"  file = {{{file_path}}}")
    lines.append("}")
    return "\n".join(lines)


def gather_qmd_files(topics: list[Path]) -> list[Path]:
    files: list[Path] = []
    for t in topics:
        files.extend(sorted(t.rglob("*.qmd")))
    return files


def extract_citation_keys(qmd_paths: list[Path]) -> set[str]:
    keys: set[str] = set()
    pattern = re.compile(r"@([A-Za-z0-9][A-Za-z0-9_:+.\-]*)")
    for path in qmd_paths:
        text = path.read_text(encoding="utf-8")
        for m in pattern.finditer(text):
            keys.add(m.group(1))
    return keys


def apply_sync(topic_filters: list[str], verbose: bool) -> int:
    topics = topic_dirs(topic_filters)
    all_ops: list[RenameOp] = []
    sources_rows: dict[Path, tuple[list[dict[str, str]], list[str]]] = {}
    errors: list[str] = []
    changes: list[str] = []

    for topic in topics:
        ops, rows, header = build_ops_for_topic(topic)
        all_ops.extend(ops)
        sources_rows[topic] = (rows, header)

    # Validate and perform rename operations.
    for op in all_ops:
        old_exists = op.old_abs.exists()
        new_exists = op.new_abs.exists()
        if old_exists and not new_exists and op.old_abs != op.new_abs:
            op.old_abs.rename(op.new_abs)
            changes.append(f"renamed {op.old_abs.relative_to(ROOT)} -> {op.new_abs.relative_to(ROOT)}")
            old_exists = False
            new_exists = True
        elif old_exists and new_exists and op.old_abs != op.new_abs:
            if sha256(op.old_abs) == sha256(op.new_abs):
                op.old_abs.unlink()
                changes.append(f"removed duplicate {op.old_abs.relative_to(ROOT)} (already migrated)")
                old_exists = False
            else:
                errors.append(
                    f"[collision] {op.new_abs.relative_to(ROOT)} exists with different content from {op.old_abs.relative_to(ROOT)}"
                )
        elif not old_exists and not new_exists:
            errors.append(f"[path-mismatch] missing both source and target files for {op.old_path}")

        if not op.new_abs.exists():
            errors.append(f"[missing-rename] expected target file not found: {op.new_path}")

    if errors:
        print_errors(errors)
        return 1

    # Update sources.csv rows for expected path.
    path_replacements: dict[Path, list[tuple[str, str]]] = {}
    name_replacements: dict[Path, list[tuple[str, str]]] = {}

    ops_by_topic: dict[Path, list[RenameOp]] = {}
    for op in all_ops:
        ops_by_topic.setdefault(op.topic_dir, []).append(op)

    for topic, ops in ops_by_topic.items():
        rows, header = sources_rows[topic]
        changed = False
        for row in rows:
            rel = (row.get("path") or "").strip()
            if not rel:
                continue
            for op in ops:
                if rel == op.old_path or rel == op.new_path:
                    if rel != op.new_path:
                        row["path"] = op.new_path
                        changed = True
                    break
        if changed:
            write_sources_csv(topic / "meta" / "sources.csv", rows, header)
            changes.append(f"updated {topic.relative_to(ROOT) / 'meta' / 'sources.csv'}")

        path_replacements[topic] = [(op.old_path, op.new_path) for op in ops if op.old_path != op.new_path]
        name_replacements[topic] = [(op.old_name, op.new_name) for op in ops if op.old_name != op.new_name]

    # Rewrite other topic files.
    for topic in topics:
        p_repl = path_replacements.get(topic, [])
        n_repl = name_replacements.get(topic, [])
        if not p_repl and not n_repl:
            continue

        meta_dir = topic / "meta"
        for csv_path in sorted(meta_dir.glob("*.csv")):
            if csv_path.name == "sources.csv":
                continue
            if rewrite_text_file(csv_path, p_repl):
                changes.append(f"updated {csv_path.relative_to(ROOT)}")

        topic_id = topic.name.split("_", 1)[0]
        docs: list[Path] = [topic / f"{topic_id}_agent_working_note.md"] + sorted(topic.rglob("*.qmd"))
        for doc in docs:
            if not doc.exists():
                continue
            repl = list(p_repl) + list(n_repl)
            if rewrite_text_file(doc, repl):
                changes.append(f"updated {doc.relative_to(ROOT)}")

    # Bibliography synchronization.
    entries = load_bib_entries(BIB_PATH)
    key_to_index = {e.key: i for i, e in enumerate(entries)}
    norm_title_year_to_keys: dict[tuple[str, str], list[str]] = {}
    for e in entries:
        key = (normalize_title(e.title), (e.year or "").strip())
        norm_title_year_to_keys.setdefault(key, []).append(e.key)

    used_ops = all_ops
    key_renames: dict[str, str] = {}

    for op in used_ops:
        if op.source_key in key_to_index:
            continue
        sig = (normalize_title(op.title), op.year.strip())
        candidates = [k for k in norm_title_year_to_keys.get(sig, []) if k != op.source_key]
        if len(candidates) == 1 and candidates[0] not in key_renames:
            old_key = candidates[0]
            idx = key_to_index[old_key]
            if op.source_key in key_to_index:
                errors.append(f"[missing-bib-key] cannot rekey {old_key} -> {op.source_key}: destination exists")
                continue
            old_raw = entries[idx].raw
            new_raw = re.sub(
                rf"^@({re.escape(entries[idx].entry_type)})\{{{re.escape(old_key)},",
                rf"@\1{{{op.source_key},",
                old_raw,
                count=1,
                flags=re.MULTILINE,
            )
            entries[idx].raw = new_raw
            entries[idx].key = op.source_key
            key_renames[old_key] = op.source_key
            del key_to_index[old_key]
            key_to_index[op.source_key] = idx
            norm_title_year_to_keys[sig] = [op.source_key if k == old_key else k for k in norm_title_year_to_keys[sig]]
            changes.append(f"rekeyed bib entry {old_key} -> {op.source_key}")
        elif len(candidates) == 0:
            entry_type = infer_bib_type(op.source_type, op.new_path)
            raw = format_bib_entry(entry_type, op.source_key, op.title, op.year, op.new_path)
            entries.append(
                BibEntry(
                    entry_type=entry_type,
                    key=op.source_key,
                    raw=raw,
                    title=op.title,
                    year=op.year,
                )
            )
            key_to_index[op.source_key] = len(entries) - 1
            changes.append(f"added bib entry {op.source_key}")
        else:
            errors.append(
                f"[missing-bib-key] ambiguous title/year match for {op.source_key}: candidates={','.join(candidates)}"
            )

    if errors:
        print_errors(errors)
        return 1

    new_bib_text = serialize_bib(entries)
    old_bib_text = BIB_PATH.read_text(encoding="utf-8")
    if new_bib_text != old_bib_text:
        BIB_PATH.write_text(new_bib_text, encoding="utf-8")
        changes.append(f"updated {BIB_PATH.relative_to(ROOT)}")

    # Update citations in qmd files only for rekeyed keys.
    if key_renames:
        qmds = gather_qmd_files(topics)
        for qmd in qmds:
            text = qmd.read_text(encoding="utf-8")
            updated = text
            for old_key, new_key in key_renames.items():
                updated = re.sub(rf"@{re.escape(old_key)}\b", f"@{new_key}", updated)
            if updated != text:
                qmd.write_text(updated, encoding="utf-8")
                changes.append(f"updated citations in {qmd.relative_to(ROOT)}")

    # Post-check validations.
    check_errors = run_validations(topics, verbose=verbose)
    if check_errors:
        print_errors(check_errors)
        return 1

    if verbose:
        for c in changes:
            print(f"[apply] {c}")
    print(f"[sync] apply complete: {len(changes)} change(s)")
    return 0


def run_validations(topics: list[Path], verbose: bool) -> list[str]:
    errors: list[str] = []
    all_ops: list[RenameOp] = []
    for topic in topics:
        ops, _, _ = build_ops_for_topic(topic)
        all_ops.extend(ops)

    for op in all_ops:
        # Validate filename convention and path match.
        expected_name = op.new_name
        current_name = Path(op.old_path).name
        if current_name != expected_name:
            errors.append(
                f"[missing-rename] {op.topic_dir.relative_to(ROOT)} source_key={op.source_key} path={op.old_path} expected basename={expected_name}"
            )
        if op.old_path != op.new_path:
            errors.append(
                f"[path-mismatch] {op.topic_dir.relative_to(ROOT)} source_key={op.source_key} path={op.old_path} expected={op.new_path}"
            )
        if not op.new_abs.exists():
            errors.append(f"[missing-rename] file not found: {op.new_path}")

    entries = load_bib_entries(BIB_PATH)
    bib_keys = {e.key for e in entries}
    for op in all_ops:
        if op.source_key not in bib_keys:
            errors.append(
                f"[missing-bib-key] {op.source_key} missing in {BIB_PATH.relative_to(ROOT)} for {op.topic_dir.name}"
            )

    qmds = gather_qmd_files(topics)
    cited = extract_citation_keys(qmds)
    missing_citations = sorted(cited - bib_keys)
    for key in missing_citations:
        errors.append(f"[unresolved-citation-key] {key} (referenced in topic qmd, missing from bibliography)")

    if verbose and not errors:
        print("[check] all validations passed")
    return errors


def print_errors(errors: list[str]) -> None:
    print("[sync][fail] validation failed")
    for err in sorted(set(errors)):
        print(err)


def main() -> int:
    parser = argparse.ArgumentParser(description="Synchronize refs-sources filenames and bibliography keys.")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--apply", action="store_true", help="Apply renames and rewrites.")
    mode.add_argument("--check", action="store_true", help="Validate only (no mutations).")
    parser.add_argument("--topic", action="append", default=[], help="Topic folder name filter (repeatable).")
    parser.add_argument("--verbose", action="store_true", help="Verbose output.")
    args = parser.parse_args()

    try:
        topics = topic_dirs(args.topic)
        if args.check:
            errors = run_validations(topics, verbose=args.verbose)
            if errors:
                print_errors(errors)
                return 1
            print("[sync] check passed")
            return 0
        return apply_sync(args.topic, verbose=args.verbose)
    except RuntimeError as e:
        print(f"[sync][fail] {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
