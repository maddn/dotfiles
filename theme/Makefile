.PHONY: theme install-tools nvim-theme codex-theme

.DELETE_ON_ERROR:
.SECONDEXPANSION:

# Leave application variables untouched when substituting the palette.
PALETTE_VARS = $(shell sed -n 's/^\([A-Z_][A-Z_0-9]*\)=.*/$$\1/p' palette.env)

VIM_PACK = $(HOME)/.local/share/nvim/site/pack
TINTED_BUILDER = $(HOME)/.local/bin/tinted-builder-rust

TINTED_NVIM = $(VIM_PACK)/plugin/start/tinted-nvim
TINTED_NVIM_PALETTE = $(TINTED_NVIM)/lua/tinted-nvim/palettes/tinted8-maddn.lua
TINTED_NVIM_COLORSCHEME = $(TINTED_NVIM)/colors/tinted8-maddn.vim

TINTED_VSCODE = $(HOME)/.local/share/tinted-theming/tinted-vscode
TINTED_VSCODE_THEMES = $(TINTED_VSCODE)/themes/tinted8

THEME_FILES = \
	alacritty.toml \
	lnav.json \
	maddn.vim \
	tinted8.yaml

THEME_PATHS = $(addprefix generated/,$(THEME_FILES))

theme: $(THEME_PATHS) generated/tmuxline.conf nvim-theme codex-theme

nvim-theme: generated/tinted8-maddn.lua generated/tinted8-maddn.vim \
	generated/nvim-overrides.lua

codex-theme: generated/maddn.tmTheme

install-tools: $(TINTED_BUILDER) $(TINTED_VSCODE)

$(THEME_PATHS): palette.env templates/$$(@F).template | generated
	set -a; . ./palette.env; \
	  envsubst '$(PALETTE_VARS)' < templates/$(@F).template > $@

generated/tinted8-maddn.lua generated/tinted8-maddn.vim &: \
		generated/tinted8.yaml | generated
	rm -f $(TINTED_NVIM_PALETTE) $(TINTED_NVIM_COLORSCHEME)
	$(TINTED_BUILDER) build $(TINTED_NVIM) \
	  --schemes-dir $(CURDIR)/generated --quiet
	cp $(TINTED_NVIM_PALETTE) $(TINTED_NVIM_COLORSCHEME) $(@D)

generated/nvim-overrides.lua: generated/tinted8.yaml \
		tinted-overrides/nvim/templates/nvim-overrides.lua.mustache | generated
	$(TINTED_BUILDER) build tinted-overrides/nvim \
	  --schemes-dir generated --quiet

generated/tmuxline.conf: generated/maddn.vim tmuxline.vim | generated
	TMUX= nvim --headless -u NONE -i NONE -n -S tmuxline.vim \
	  -c 'call GenerateTmuxline()' \
	  -c 'if !empty(v:errmsg) | cquit | endif' -c qa

generated/maddn.tmTheme: generated/tinted8.yaml \
		tinted-overrides/codex/templates/codex-overrides.json.mustache | generated
	$(TINTED_BUILDER) build $(TINTED_VSCODE) \
	  --schemes-dir $(CURDIR)/generated --quiet
	$(TINTED_BUILDER) build tinted-overrides/codex \
	  --schemes-dir generated --quiet
	python3 vscode_to_tmtheme.py $(TINTED_VSCODE_THEMES)/tinted8-maddn.json \
	  $(TINTED_VSCODE_THEMES)/codex-overrides.json $@

generated:
	mkdir -p $@

$(TINTED_BUILDER):
	[ -d $(@D) ] || mkdir -p $(@D)
	curl -fsSL "https://github.com/tinted-theming/tinted-builder-rust/releases/latest/download/tinted-builder-rust-$$(uname -m)-unknown-linux-gnu.tar.gz" | \
	  tar -xz -C $(@D) tinted-builder-rust

$(TINTED_VSCODE):
	[ -d $(@D) ] || mkdir -p $(@D)
	git clone --depth 1 https://github.com/tinted-theming/tinted-vscode.git $@
