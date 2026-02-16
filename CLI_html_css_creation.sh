#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

OUTPUT_DIR="html_build"
mkdir -p "$OUTPUT_DIR"

if [[ -f "style.css" ]]; then
    cp style.css "$OUTPUT_DIR/style.css"
fi

declare -A FILES_MAP=( 
    ["cv.tex"]="fr" 
    ["cv_en.tex"]="en" 
)

TEMPLATE="cv_template.html"

for INPUT in "${!FILES_MAP[@]}"; do
    LANG_CODE="${FILES_MAP[$INPUT]}"

    if [[ ! -f "$INPUT" ]]; then
        echo "⚠️  Warning: Input file '$INPUT' not found. Skipping."
        continue
    fi

    if [[ "$LANG_CODE" == "fr" ]]; then
        JOB_TITLE="Stage DevOps"
        SUBTITLE="Recherche un stage de DevOps de 6 mois"
        LABEL_PHONE="Téléphone:"
        LOCATION="Ville: Paris 02, France"
        TITLE_META="CV - $NAME"
    else
        JOB_TITLE="DevOps Internship"
        SUBTITLE="Looking for a 6-month DevOps internship"
        LABEL_PHONE="Phone:"
        LOCATION="Location: Paris 02, France"
        TITLE_META="Resume - $NAME"
    fi

    OUTPUT_BASENAME="$(basename "$INPUT" .tex)"
    TEMP_INPUT="${OUTPUT_BASENAME}_build.tex"

    echo "Processing $INPUT ($LANG_CODE)..."

    {
      echo '\def\ishtml{1}'
      echo '\newcommand{\makecvheader}{}'
      echo '\newcommand{\cvsection}[1]{\section*{#1}}'
      cat "$INPUT"
    } | envsubst '$MAIL $PHONE $NAME' > "$TEMP_INPUT"

    pandoc "$TEMP_INPUT" \
      -o "${OUTPUT_DIR}/${OUTPUT_BASENAME}.html" \
      --standalone \
      --template="$TEMPLATE" \
      --css="style.css" \
      --shift-heading-level-by=1 \
      -V NAME="$NAME" \
      -V MAIL="$MAIL" \
      -V PHONE="$PHONE" \
      -V lang="$LANG_CODE" \
      -V job_title="$JOB_TITLE" \
      -V subtitle="$SUBTITLE" \
      -V label_phone="$LABEL_PHONE" \
      -V location="$LOCATION" \
      --metadata title="$TITLE_META"

    rm "$TEMP_INPUT"
    echo "✅ Generated: ${OUTPUT_BASENAME}.html"
done