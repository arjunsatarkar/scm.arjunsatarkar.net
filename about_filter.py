#!/usr/bin/env python3
import subprocess
import sys

filename = sys.argv[1]

result = None

if filename.endswith(".adoc"):
    result = subprocess.check_output(
        [
            "asciidoctor",
            "--safe-mode",
            "secure",
            "-a",
            "showtitle",
            "-e",
            "-",
        ]
    ).decode("utf-8")
elif filename.endswith(".md"):
    result = subprocess.check_output(
        [
            "pandoc",
            "-f",
            "gfm",
            "-t",
            "html",
            "-",
        ]
    ).decode("utf-8")
else:
    result = sys.stdin.read()

print(result)
