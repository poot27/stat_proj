#!/bin/bash
#Usage: -i INPUT_FILE -o OUTPUT_FILE"

# Parse command line options
while getopts "i:o:" opt; do
    case ${opt} in
        i) INPUT_FILE=${OPTARG} ;;
        o) OUTPUT_FILE=${OPTARG} ;;
        *) exit 1 ;;
    esac
done

# Process each line in the input file
while IFS= read -r line; do
    # Separate the date from the entries
    DATE="${line%%:*}"
    ENTRIES="${line#*: }"

    # Check if current line has any fails
    if [[ $ENTRIES == *"fail"* ]]; then
        status="fail"
    else
        status="pass"
    fi

    # Log the result
    echo "$DATE: $status" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# Echo numbers
FAIL=$(grep -o 'fail' "$OUTPUT_FILE" | wc -l)
PASS=$(grep -o 'pass' "$OUTPUT_FILE" | wc -l)
TOTAL=$(wc -l < "$OUTPUT_FILE")
echo "Summary is $FAIL fails, $PASS passes, total is $TOTAL"
echo "Results saved to $OUTPUT_FILE"
