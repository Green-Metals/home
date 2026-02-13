#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for topic in "topic01_copper" "topic02_iron-steel" "topic03_alumina-aluminium"; do
  src_pdf="${ROOT_DIR}/_site/${topic}/WRITEUP.pdf"
  dst_pdf="${ROOT_DIR}/${topic}/WRITEUP.pdf"
  if [[ -f "${src_pdf}" ]]; then
    cp "${src_pdf}" "${dst_pdf}"
  fi
done
