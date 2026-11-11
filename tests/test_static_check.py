"""Behavior tests for static check's coverage and disclosure boundaries."""
import subprocess
import tempfile
import unittest
from pathlib import Path

CHECKER = Path(__file__).resolve().parents[1] / "skills/web-review-loop/scripts/static-check.mjs"


class StaticCheckTests(unittest.TestCase):
    def run_scan(self, directory):
        return subprocess.run(["node", str(CHECKER), str(directory)], capture_output=True, text=True, encoding="utf-8")

    def test_empty_project_is_skipped(self):
        with tempfile.TemporaryDirectory() as directory:
            result = self.run_scan(directory)
            self.assertEqual(result.returncode, 2)
            self.assertIn("SKIPPED", result.stdout)

    def test_navigation_is_not_mixed_content_and_values_not_disclosed(self):
        with tempfile.TemporaryDirectory() as directory:
            Path(directory, "index.html").write_text('''<html lang="ko"><head><title>T</title><meta name="viewport" content="width=device-width"></head><body><h1>A</h1><h1>B</h1><a href="http://example.com/">link</a><img src="/private-token.png"><input aria-label="private-token"></body></html>''', encoding="utf-8")
            result = self.run_scan(directory)
            self.assertEqual(result.returncode, 0)
            self.assertNotIn("mixed content", result.stdout)
            self.assertNotIn("exactly 1", result.stdout)
            self.assertNotIn("private-token", result.stdout)
            self.assertIn("possible img without alt", result.stdout)
            self.assertIn("Heuristic scan only", result.stdout)

    def test_http_resource_is_candidate_without_url(self):
        with tempfile.TemporaryDirectory() as directory:
            Path(directory, "index.html").write_text('''<html lang="ko"><head><title>T</title><meta name="viewport" content="x"></head><body><script src="http://example.com/a.js?token=private-token"></script></body></html>''', encoding="utf-8")
            result = self.run_scan(directory)
            self.assertIn("HTTP subresource", result.stdout)
            self.assertNotIn("private-token", result.stdout)


if __name__ == "__main__":
    unittest.main()
