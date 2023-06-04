#!/usr/bin/env python3
import html
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
            "--sandbox",
            "-",
        ]
    ).decode("utf-8")
else:
    result = f"<pre>{html.escape(sys.stdin.read())}</pre>"

print(result)
