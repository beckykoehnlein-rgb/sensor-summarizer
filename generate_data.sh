
#!/usr/bin/env bash

set -e

# Check for missing argument
if [ -z "$1" ]; then
    echo "Usage: ./generate_data.sh NUM_FILES"
    exit 1
fi

# Number of files and rows
NUM_FILES="$1"
ROWS=20

# Create data directory
mkdir -p data

# Generate sensor files
for i in $(seq 1 "$NUM_FILES"); do

    FILE="data/sensor_${i}.csv"

    echo "Generating $FILE"

    # Write CSV header
    echo "timestamp,temperature,humidity" > "$FILE"

    # Select 3 random rows for even-numbered files
    if (( i % 2 == 0 )); then
        nums=$(shuf -i 1-"$ROWS" -n 3)
    fi

    # Generate 20 data rows
    for j in $(seq 1 "$ROWS"); do

        timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        # Generate normal temperature
        temperature=$(( RANDOM % 10 + 70 ))

        if (( i % 2 == 0 )); then

            # Check whether this row is one of the 3 random bad rows
            if [[ " $nums " == *" $j "* ]]; then

                # Randomly choose a type of bad temperature
                case $(( RANDOM % 3 )) in
                    0)
                        temperature="not_a_number"
                        ;;
                    1)
                        temperature=200
                        ;;
                    2)
                        temperature=""
                        ;;
                esac

            fi
        fi

        echo "${timestamp},${temperature},60" >> "$FILE"

    done

done

echo "Successfully generated $NUM_FILES sensor files."
