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

formatter = HtmlFormatter(style="monokai", nowrap=True)

print(
    f'<span class="highlight" style="display: block;">{highlight(source, lexer, formatter)}</span>'
)
