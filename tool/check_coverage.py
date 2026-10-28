"""Enforce coverage of instrumented handwritten Dart; exclude generated output."""
import sys
from pathlib import Path

THRESHOLDS = {"overall": 85, "domain": 90, "data": 85, "session": 80}


def coverage_records(source):
    records = {}
    current = None
    for raw in source.splitlines():
        if raw.startswith("SF:"):
            path = raw[3:].replace("\\", "/")
            if "/lib/" in path:
                path = "lib/" + path.split("/lib/", 1)[1]
            current = path if path.startswith("lib/") and "/generated/" not in path and not path.endswith((".g.dart", ".freezed.dart")) else None
        elif raw.startswith("DA:") and current:
            number, hits, *_ = raw[3:].split(",")
            key = (current, int(number))
            records[key] = records.get(key, False) or int(hits) > 0
    return records


def check(records):
    predicates = {
        "overall": lambda path: True,
        "domain": lambda path: "/domain/" in path,
        "data": lambda path: "/data/" in path,
        "session": lambda path: path.endswith("/speedometer_controller.dart"),
    }
    failed = False
    for name, minimum in THRESHOLDS.items():
        lines = [hit for (path, _), hit in records.items() if predicates[name](path)]
        percent = 100 * sum(lines) / len(lines) if lines else 0
        passed = bool(lines) and percent >= minimum
        print(f"{name}: {sum(lines)}/{len(lines)} ({percent:.1f}%), required {minimum}%: {'PASS' if passed else 'FAIL'}")
        failed |= not passed
    return not failed


if __name__ == "__main__":
    source = Path(sys.argv[1] if len(sys.argv) > 1 else "coverage/lcov.info")
    sys.exit(0 if check(coverage_records(source.read_text())) else 1)
