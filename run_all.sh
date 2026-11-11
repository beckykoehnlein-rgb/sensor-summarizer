#!/usr/bin/env bash
# Runs summarize.py on every CSV in data/ and reports PASS/FAIL
# Usage: ./run_all.sh

LOG="output/run_$(date +%Y%m%d_%H%M%S).log"
PASSED=0
FAILED=0

if [ -z "$(ls -A data)" ]; then
    echo "Empty data"
    exit 1
fi

for file in data/*; do
    python3 summarize.py "$file" > /dev/null
    code=$?

    if [ "$code" -eq 0 ]; then
        echo "PASS $file"
        echo "PASS $file" >> "$LOG"
        PASSED=$((PASSED + 1))
    else
        echo "FAIL $file"
        echo "FAIL $file" >> "$LOG"
        FAILED=$((FAILED + 1))
    fi
done
echo "Summary: $PASSED passed, $FAILED failed" 
echo "Summary: $PASSED passed, $FAILED failed" >> "$LOG"

if [ "$FAILED" -gt 0 ]; then
    exit 1
else
    exit 0
fi
