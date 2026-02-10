#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
  echo "Error: input .tex file is required." >&2
  exit 1
fi

OUTPUT_BASENAME="$(basename "$INPUT" .tex)"
OUTPUT_DIR="html_build"
TEMPLATE="cv_template.html"
TEMP_INPUT="${OUTPUT_BASENAME}_build.tex"

mkdir -p "$OUTPUT_DIR"

echo "Applying HTML transformations..."

{
  echo '\def\ishtml{1}'
  echo '\newcommand{\makecvheader}{}'
  echo '\newcommand{\cvsection}[1]{\section*{#1}}'
  cat "$INPUT"
} | envsubst '$MAIL $PHONE $NAME' > "$TEMP_INPUT"

echo "Compiling HTML via Pandoc..."
pandoc "$TEMP_INPUT" \
  -o "${OUTPUT_DIR}/${OUTPUT_BASENAME}.html" \
  --standalone \
  --template="$TEMPLATE" \
  --css="style.css" \
  --shift-heading-level-by=1 \
  -V NAME="$NAME" \
  -V MAIL="$MAIL" \
  -V PHONE="$PHONE" \
  --metadata title="CV - $NAME"

if [[ -f "style.css" ]]; then
    cp style.css "$OUTPUT_DIR/style.css"
fi

rm "$TEMP_INPUT"
echo "Done: $OUTPUT_DIR/${OUTPUT_BASENAME}.html"

