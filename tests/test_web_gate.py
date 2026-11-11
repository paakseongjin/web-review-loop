"""Behavioral checks for the gate's exit status and output privacy."""
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

GATE = Path(__file__).resolve().parents[1] / 'skills/web-review-loop/scripts/web-gate.sh'
BASH = shutil.which('bash')
NODE = shutil.which('node')
NPM = shutil.which('npm')

@unittest.skipUnless(BASH, 'bash is unavailable')
class GateTests(unittest.TestCase):
    def run_gate(self, directory, env=None):
        return subprocess.run([BASH, str(GATE), str(directory)], capture_output=True,
                              text=True, encoding='utf-8', errors='replace', env=env)

    def test_no_tools_or_checks_returns_skipped(self):
        with tempfile.TemporaryDirectory() as directory:
            env = os.environ.copy()
            env['PATH'] = directory
            result = self.run_gate(directory, env)
            self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
            self.assertIn('PASS=0 FAIL=0', result.stdout)
            self.assertIn('SKIPPED', result.stdout)

    @unittest.skipUnless(NODE and NPM, 'Node and npm are unavailable')
    def test_failing_command_output_is_not_disclosed(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / 'package.json').write_text(json.dumps({'scripts': {
                'test': 'node -e "console.error(\'FAKE_SECRET_VALUE_FOR_TEST\'); process.exit(1)"'
            }}), encoding='utf-8')
            result = self.run_gate(project)
            self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
            self.assertIn('FAIL', result.stdout)
            self.assertNotIn('FAKE_SECRET_VALUE_FOR_TEST', result.stdout + result.stderr)

    @unittest.skipUnless(NODE and NPM, 'Node and npm are unavailable')
    def test_successful_project_check_returns_zero(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / 'package.json').write_text(json.dumps({'scripts': {
                'test': 'node -e "process.exit(0)"'
            }}), encoding='utf-8')
            result = self.run_gate(project)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('| tests | PASS |', result.stdout)

if __name__ == '__main__':
    unittest.main()
