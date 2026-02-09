#!/bin/bash

set -e

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "❌ Usage: $0 <file1> <file2>"
    echo "Example: $0 1.jpg 5.jpg"
    exit 1
fi

FILE1="$1"
FILE2="$2"
TMP_FILE=".__swap_tmp__$$"

# Check if both files exist
if [ ! -e "$FILE1" ] || [ ! -e "$FILE2" ]; then
    echo "❌ One or both files do not exist."
    exit 1
fi

echo "🔁 Swapping:"
echo "   $FILE1 ↔ $FILE2"

# Swap using temporary file
mv -- "$FILE1" "$TMP_FILE"
mv -- "$FILE2" "$FILE1"
mv -- "$TMP_FILE" "$FILE2"

echo "✅ Swap complete!"
