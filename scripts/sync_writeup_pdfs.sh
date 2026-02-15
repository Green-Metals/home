#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOPICS_ALL=(
  "topic00_landscape-briefing"
  "topic01_copper"
  "topic02_iron-steel"
  "topic03_alumina-aluminium"
)

writeup_base_for_topic() {
  case "$1" in
    topic00_landscape-briefing) echo "topic00_agent_writeup" ;;
    topic01_copper) echo "topic01_agent_writeup" ;;
    topic02_iron-steel) echo "topic02_agent_writeup" ;;
    topic03_alumina-aluminium) echo "topic03_agent_writeup" ;;
    *) return 1 ;;
  esac
}

parse_topics_from_env() {
  local raw="${SYNC_WRITEUP_TOPICS:-}"
  if [[ -z "$raw" ]]; then
    return 0
  fi
  local normalized="${raw//,/ }"
  for topic in $normalized; do
    printf '%s\n' "$topic"
  done
}

TOPICS=()
TOPICS_FROM_ENV_SET=0
if [[ "${SYNC_WRITEUP_TOPICS+x}" == "x" ]]; then
  TOPICS_FROM_ENV_SET=1
fi
while [[ $# -gt 0 ]]; do
  case "$1" in
    --topic)
      [[ $# -ge 2 ]] || { echo "[sync-writeup][fail] --topic requires a value"; exit 1; }
      TOPICS+=("$2")
      shift 2
      ;;
    *)
      echo "[sync-writeup][fail] unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ ${#TOPICS[@]} -eq 0 ]]; then
  if [[ "$TOPICS_FROM_ENV_SET" == "1" ]]; then
    while IFS= read -r topic; do
      [[ -n "$topic" ]] && TOPICS+=("$topic")
    done < <(parse_topics_from_env)
  fi
fi

if [[ ${#TOPICS[@]} -eq 0 && "$TOPICS_FROM_ENV_SET" == "0" ]]; then
  TOPICS=("${TOPICS_ALL[@]}")
fi

STRICT="${SYNC_WRITEUP_STRICT:-0}"

if [[ ${#TOPICS[@]} -eq 0 ]]; then
  exit 0
fi

rm -rf "${ROOT_DIR}/site/_site"

for topic in "${TOPICS[@]}"; do
  writeup_base="$(writeup_base_for_topic "$topic")" || { echo "[sync-writeup][fail] unsupported topic: $topic"; exit 1; }
  src_dir="${ROOT_DIR}/site/${topic}"
  dst_dir="${ROOT_DIR}/content/topics/${topic}"
  src_html="${src_dir}/${writeup_base}.html"
  src_pdf="${src_dir}/${writeup_base}.pdf"
  dst_html="${dst_dir}/${writeup_base}.html"
  dst_pdf="${dst_dir}/${writeup_base}.pdf"

  rm -f "${src_dir}/WRITEUP.html" "${src_dir}/WRITEUP.pdf" "${dst_dir}/WRITEUP.html" "${dst_dir}/WRITEUP.pdf"

  if [[ ! -f "$src_html" || ! -f "$src_pdf" ]]; then
    if [[ "$STRICT" == "1" ]]; then
      [[ -f "$src_html" ]] || echo "[sync-writeup][fail] missing rendered HTML for ${topic}: ${src_html}"
      [[ -f "$src_pdf" ]] || echo "[sync-writeup][fail] missing rendered PDF for ${topic}: ${src_pdf}"
      exit 1
    fi
    [[ -f "$src_html" ]] || echo "[sync-writeup][warn] missing rendered HTML for ${topic}: ${src_html} (strict=0, skipping)"
    [[ -f "$src_pdf" ]] || echo "[sync-writeup][warn] missing rendered PDF for ${topic}: ${src_pdf} (strict=0, skipping)"
    continue
  fi

  cp "$src_html" "$dst_html"
  cp "$src_pdf" "$dst_pdf"
done
