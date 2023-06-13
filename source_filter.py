#!/usr/bin/env python3
from pygments import highlight
from pygments.formatters import HtmlFormatter
from pygments.lexers import guess_lexer, guess_lexer_for_filename
from pygments.lexers.special import TextLexer
from pygments.util import ClassNotFound
import sys

source = sys.stdin.read()

try:
    lexer = guess_lexer_for_filename(sys.argv[1], source)
except ClassNotFound:
    try:
        lexer = guess_lexer(source)
    except ClassNotFound:
        lexer = TextLexer()

formatter = HtmlFormatter(style="monokai", nobackground=True)

sys.stdout.write(f"<style>{formatter.get_style_defs('.highlight')}</style>")
sys.stdout.write(highlight(source, lexer, formatter))
print()
