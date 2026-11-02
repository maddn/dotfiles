# Pygments formatter using terminal palette colours.

from pygments.formatters.terminal import TerminalFormatter
from pygments.token import Keyword, Name, Comment, String, Error, \
    Number, Operator, Generic, Token, Whitespace

TERMINAL_COLORS = {
    Token:              ('',        ''),

    Whitespace:         ('gray',    'gray'),
    Comment:            ('cyan',    'cyan'),
    Comment.Preproc:    ('magenta', 'magenta'),
    Keyword:            ('blue',    'blue'),
    Keyword.Constant:   ('red',     'red'),
    Keyword.Type:       ('green',   'green'),
    Operator.Word:      ('red',     'red'),
    Name.Builtin:       ('green',   'green'),
    Name.Builtin.Pseudo: ('gray',   'gray'),
    Name.Function:      ('green',   'green'),
    Name.Namespace:     ('green',   'green'),
    Name.Class:         ('green',   'green'),
    Name.Exception:     ('magenta', 'magenta'),
    Name.Decorator:     ('magenta', 'magenta'),
    Name.Variable:      ('gray',    'gray'),
    Name.Constant:      ('red',     'red'),
    Name.Attribute:     ('green',   'green'),
    Name.Tag:           ('blue',    'blue'),
    String:             ('yellow',  'yellow'),
    Number:             ('red',     'red'),

    Generic.Deleted:    ('red',     'red'),
    Generic.Inserted:   ('green',   'green'),
    Generic.Heading:    ('blue',    'blue'),
    Generic.Subheading: ('cyan',    'cyan'),
    Generic.Prompt:     ('blue',    'blue'),
    Generic.Error:      ('red',     'red'),

    Error:              ('red',     'red'),
}

class CustomFormatter(TerminalFormatter):
    def __init__(self, **options):
        super().__init__(**options)
        self.colorscheme = TERMINAL_COLORS
