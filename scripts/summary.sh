#!/bin/bash
#Usage: -i INPUT_FILE -o OUTPUT_FILE"

# Parse command line options
while getopts "i:o:" opt; do
    case ${opt} in
        i) INPUT_FILE=${OPTARG} ;;
        o) OUTPUT_FILE=${OPTARG} ;;
        *) usage ;;
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

echo "Results saved to $OUTPUT_FILE."
