#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

INPUT="$1"

if [[ -z "${INPUT:-}" ]]; then
  echo "Error: input .tex file is required." >&2
  exit 1
fi

OUTPUT_BASENAME="$(basename "$INPUT" .tex)"
OUTPUT_PDF="${OUTPUT_BASENAME}.pdf"
OUTPUT_DIR="pdf"

TEMP_INPUT="${OUTPUT_BASENAME}_build.tex"

mkdir -p "$OUTPUT_DIR"

echo "Injecting environment variables..."
envsubst '$MAIL $PHONE $NAME' < "$INPUT" > "$TEMP_INPUT"

echo "Compiling $TEMP_INPUT -> $OUTPUT_PDF"

latexmk -pdf -interaction=nonstopmode -file-line-error -outdir="$OUTPUT_DIR" -jobname="$OUTPUT_BASENAME" "$TEMP_INPUT"
latexmk -c -outdir="$OUTPUT_DIR" -jobname="$OUTPUT_BASENAME" "$TEMP_INPUT"

rm "$TEMP_INPUT"
echo "Done: $OUTPUT_PDF"