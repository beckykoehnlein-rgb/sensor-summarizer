import csv

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


if __name__ == "__main__":

    result = {}

    temps, bad_rows = read_temperatures("data.csv")

    result["temps"] = temps
    result["bad_rows"] = bad_rows
    result["bad_row_count"] = len(bad_rows)

    print(result)

