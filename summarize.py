import csv
import json
import os
import sys 

MIN_TEMP = -50
MAX_TEMP = 150


def read_temperatures(path):
    """Return (temps, bad_rows) from the CSV at path."""
    temps = []
    bad_rows = []

    with open(path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)

        for line_num, row in enumerate(reader, start=2):
            value = row["temperature"]

            if value is None or value.strip() == "":
                bad_rows.append({
                    "line": line_num,
                    "reason": "missing value"
                })
                continue

            try:
                temp = float(value)

            except ValueError:
                bad_rows.append({
                    "line": line_num,
                    "reason": "not a number"
                })
                continue

            if temp < MIN_TEMP or temp > MAX_TEMP:
                bad_rows.append({
                    "line": line_num,
                    "reason": "out of range"
                })
            else:
                temps.append(temp)

    return temps, bad_rows

def summarize(temps):
    """Return a dict with count , min, max and average."""
    if not temps: 
        return {
            "count": 0, 
            "min": None, 
            "max": None, 
            "average": None, 
        }
    average = round(sum(temps) / len(temps), 2)

    return {
        "count": len(temps), 
        "min": min(temps), 
        "max": max(temps),
        "average": average,
    }

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print ("Usage: python3 summarize.py <filename>")
        sys.exit(2)

    filename = sys.argv[1]

    temps, bad_rows = read_temperatures(filename)
    result = summarize(temps)
    result["file"] = filename 
    result["bad_rows"] = bad_rows
    result ["bad_row_count"] = len(bad_rows)

    print (result) 

    os.makedirs("output", exist_ok=True)
    name = os.path.splitext(os.path.basename(filename))[0]
    out_path = os.path.join("output", f"{name}_summary.json")

    with open(out_path, "w", encoding="utf-8") as f: 
        json.dump(result, f, indent=2)

    if bad_rows: 
        sys.exit(1)

    sys.exit(0)