#!/bin/bash
# Usage: convert.sh INPUT_FILE OUTPUT_FILE
FILE=$1
OUTPUT_FILE=$2

# Create a temporary file
TEMP_FILE=$(mktemp)

# Remove the first 12 characters from each line and save to the temporary file
cut -c13- "$FILE" > "$TEMP_FILE"

# Replace 'pass' with '1', 'fail' with '0', and remove commas
sed -e 's/pass/1/g' -e 's/fail/0/g' -e 's/,//g' "$TEMP_FILE" > "$OUTPUT_FILE"

echo "Processed file $FILE, output to: $OUTPUT_FILE"
