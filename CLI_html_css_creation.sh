#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

INPUT="$1"

if [[ -z "${INPUT:-}" ]]; then
  echo "Error: input .tex file is required." >&2
  exit 1
fi

OUTPUT_BASENAME="$(basename "$INPUT" .tex)"
OUTPUT_DIR="html_build"

TEMP_INPUT="${OUTPUT_BASENAME}_build.tex"

mkdir -p "$OUTPUT_DIR"

echo "Injecting environment variables..."
envsubst '$MAIL $PHONE $NAME' < "$INPUT" > "$TEMP_INPUT"

echo "Compiling $TEMP_INPUT -> HTML in $OUTPUT_DIR/"

make4ht -d "$OUTPUT_DIR" --utf8 "$TEMP_INPUT"
make4ht -m clean "$TEMP_INPUT"

cd html_build
mv "${OUTPUT_BASENAME}_build.html" "${OUTPUT_BASENAME}.html"
mv "${OUTPUT_BASENAME}_build.css" "${OUTPUT_BASENAME}.css"
sed -i "s/${OUTPUT_BASENAME}_build.css/${OUTPUT_BASENAME}.css/g" "${OUTPUT_BASENAME}.html"
cd ..
rm "$TEMP_INPUT"

echo "Done. Files are in directory: $OUTPUT_DIR/"
