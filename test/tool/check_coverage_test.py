import importlib.util
import unittest
from pathlib import Path
from contextlib import redirect_stdout
from io import StringIO

spec = importlib.util.spec_from_file_location("coverage_gate", Path(__file__).parents[2] / "tool/check_coverage.py")
gate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gate)


class CoverageGateTest(unittest.TestCase):
    def test_excludes_generated_and_merges_repeated_line_records(self):
        source = "SF:/workspace/lib/features/a/domain/a.dart\nDA:1,0\nDA:2,0\nend_of_record\nSF:lib/features/a/domain/a.dart\nDA:1,2\nSF:lib/generated/l10n/a.dart\nDA:1,1\nSF:lib/core/a.g.dart\nDA:1,1\n"
        self.assertEqual(gate.coverage_records(source), {("lib/features/a/domain/a.dart", 1): True, ("lib/features/a/domain/a.dart", 2): False})

    def test_missing_groups_and_below_threshold_fail(self):
        with redirect_stdout(StringIO()):
            self.assertFalse(gate.check({}))
            self.assertFalse(gate.check({("lib/a.dart", 1): False}))

    def test_all_groups_at_full_coverage_pass(self):
        records = {(path, 1): True for path in ["lib/features/a/domain/a.dart", "lib/features/a/data/a.dart", "lib/features/a/presentation/speedometer_controller.dart"]}
        with redirect_stdout(StringIO()):
            self.assertTrue(gate.check(records))


if __name__ == "__main__":
    unittest.main()
