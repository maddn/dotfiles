"""Convert a generated tinted-vscode theme plus Codex overrides to TextMate.

Syntax source: https://github.com/tinted-theming/tinted-vscode
Usage: python3 theme/vscode_to_tmtheme.py \
    ~/.local/share/tinted-theming/tinted-vscode/themes/tinted8/tinted8-maddn.json \
    ~/.local/share/tinted-theming/tinted-vscode/themes/tinted8/codex-overrides.json \
    theme/generated/maddn.tmTheme
"""

import json
from pathlib import Path
import plistlib
import sys

source, overrides, output = map(Path, sys.argv[1:])
vscode = json.loads(source.read_text())
custom = json.loads(overrides.read_text())

theme = {
    "name": custom["name"],
    "author": "Generated from tinted-theming/tinted-vscode",
    "settings": [{"settings": custom["settings"]}],
}
for token in vscode["tokenColors"] + custom["tokenColors"]:
    rule = token.copy()
    if isinstance(rule["scope"], list):
        rule["scope"] = ", ".join(rule["scope"])
    theme["settings"].append(rule)

output.write_bytes(plistlib.dumps(theme, sort_keys=False))
