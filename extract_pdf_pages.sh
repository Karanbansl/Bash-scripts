#!/usr/bin/env bash

# Usage:
# ./extract_pdf_pages.sh input.pdf "1 3 5-7" output.pdf

set -e

INPUT="$1"
PAGES="$2"
OUTPUT="$3"

if [[ -z "$INPUT" || -z "$PAGES" || -z "$OUTPUT" ]]; then
  echo "Usage: $0 input.pdf \"1 3 5-7\" output.pdf"
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Error: Input file not found!"
  exit 1
fi

TMP_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Extract all pages as individual PDFs
pdfseparate "$INPUT" "$TMP_DIR/page-%03d.pdf"

# Collect selected pages
SELECTED=()

for p in $PAGES; do
  if [[ "$p" == *-* ]]; then
    start=${p%-*}
    end=${p#*-}
    for ((i=start; i<=end; i++)); do
      SELECTED+=("$TMP_DIR/page-$(printf "%03d" "$i").pdf")
    done
  else
    SELECTED+=("$TMP_DIR/page-$(printf "%03d" "$p").pdf")
  fi
done

# Merge selected pages
pdfunite "${SELECTED[@]}" "$OUTPUT"

echo "✅ Extracted pages saved to: $OUTPUT"
