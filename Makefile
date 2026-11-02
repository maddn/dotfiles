ARCH ?= arm64

DOT_FILES = \
	.alacritty.toml \
	.bash_profile \
	.docker_login.sh \
	.gitconfig \
	.pylintrc \
	.tmux.conf \
	.zshrc \
	.yang/yang.settings \
	.config/fish/config.fish \
	.config/fish/fish_variables \
	.config/fish/functions/fish_default_mode_prompt.fish \
	.config/fish/functions/fish_mode_prompt.fish \
	.config/fish/functions/fish_prompt.fish \
	.config/lnav/formats/installed/lnav_formats.json \
	.config/vifm/vifmrc \
	.docker/config.json \
	.config/nvim/init.vim

VIM_PACK = $(HOME)/.local/share/nvim/site/pack
VIM_START = .local/share/nvim/site/pack/plugin/start

THEME_DOT_FILES = \
	.dircolors \
	.tmuxline.conf \
	.codex/themes/maddn.tmTheme \
	.config/fish/themes/maddn.theme \
	.config/lnav/configs/installed/lnav.json \
	.config/pygments/pygments_formatter.py \
	.config/vifm/colors/maddn.vifm \
	$(VIM_START)/tinted-nvim/colors/tinted8-maddn.vim \
	$(VIM_START)/tinted-nvim/lua/tinted-nvim/palettes/tinted8-maddn.lua \
	$(VIM_START)/tinted-nvim/lua/tinted-nvim/highlights/nvim-overrides.lua \
	$(VIM_START)/vim-airline/autoload/airline/themes/maddn.vim

TARGET_FILES = $(DOT_FILES:%=$(HOME)/%)
THEME_TARGET_FILES = $(THEME_DOT_FILES:%=$(HOME)/%)


.DELETE_ON_ERROR:
.PHONY: all vim treesitter fish vim-helptags clean theme theme-install-tools

all: vim $(TARGET_FILES) $(THEME_TARGET_FILES) fish vim-helptags \
	theme-install-tools


## Vim ##

VIM_PACK_NAMES = plugin syntax tmux github

NPM_LSP = $(HOME)/.local/bin/pyright-langserver \
	$(HOME)/.local/bin/tsc \
	$(HOME)/.local/bin/vscode-eslint-language-server \
	$(HOME)/.local/bin/vscode-css-language-server \
	$(HOME)/.local/bin/vscode-json-language-server \
	$(HOME)/.local/bin/yaml-language-server

vim: $(VIM_PACK_NAMES:%=$(VIM_PACK)/%/start) $(NPM_LSP) treesitter \
	$(HOME)/.local/bin/yang-language-server \
	$(HOME)/.local/bin/lemminx \
	$(HOME)/.local/bin/make-ls

$(VIM_PACK)/plugin/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/vim-airline/vim-airline.git
	git -C $@ clone https://github.com/tinted-theming/tinted-nvim.git
	git -C $@ clone https://github.com/nvim-mini/mini.bufremove.git
	git -C $@ clone https://github.com/tpope/vim-fugitive.git
	git -C $@ clone https://github.com/lewis6991/gitsigns.nvim.git
	git -C $@ clone https://github.com/preservim/nerdtree.git

$(VIM_PACK)/syntax/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/mfussenegger/nvim-lint.git
	git -C $@ clone https://github.com/neovim/nvim-lspconfig
	git -C $@ clone https://github.com/ray-x/lsp_signature.nvim.git
	git -C $@ clone https://github.com/nvim-treesitter/nvim-treesitter.git

$(VIM_PACK)/tmux/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/edkolev/tmuxline.vim.git
	git -C $@/tmuxline.vim apply $(CURDIR)/theme/tmuxline.patch
	git -C $@ clone https://github.com/christoomey/vim-tmux-navigator.git

$(VIM_PACK)/github/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/github/copilot.vim


## Tree-Sitter ##

treesitter: $(VIM_PACK)/syntax/start $(HOME)/.local/bin/tree-sitter
	printf '%s\n' "vim.cmd.packadd('nvim-treesitter')" \
	  "assert(require('nvim-treesitter').install({" \
	  "  'javascript', 'python', 'yang' }):wait(300000))" | \
	  nvim --headless -u NONE -i NONE -n -l -

$(HOME)/.local/bin/tree-sitter:
	[ -d $(@D) ] || mkdir -p $(@D)
	curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${ARCH}.gz" | \
	  gzip -d > $@ && \
	chmod +x $@


## Language Servers ##

$(NPM_LSP) &:
	npm i -g pyright typescript vscode-langservers-extracted yaml-language-server
	npm cache clean --force

$(HOME)/.local/bin/yang-language-server:
	[ -d $(@D) ] || mkdir -p $(@D)
	curl -fsSL "https://github.com/TypeFox/yang-lsp/releases/download/v0.7.6/yang-language-server_0.7.6.zip" \
	  -o /tmp/yang-language-server.zip && \
	unzip -q /tmp/yang-language-server.zip -d $(HOME)/.local/lib && \
	ln -s $(HOME)/.local/lib/yang-language-server-0.7.6/bin/yang-language-server $@ && \
	rm /tmp/yang-language-server.zip

$(HOME)/.local/bin/lemminx:
	[ -d $(@D) ] || mkdir -p $(@D)
	LEMMINX_ARCH=$$(uname -m | sed 's/aarch64/aarch_64/') && \
	curl -fsSL "https://github.com/redhat-developer/vscode-xml/releases/latest/download/lemminx-linux-$${LEMMINX_ARCH}.zip" | \
	  funzip > $@ && \
	chmod +x $@

$(HOME)/.local/bin/make-ls:
	[ -d $(@D) ] || mkdir -p $(@D)
	curl -fsSL "https://github.com/owenrumney/make-ls/releases/download/v0.1.25/make-ls_linux_${ARCH}.tar.gz" | \
	  tar -xz -C $(@D) make-ls

vim-helptags:
	for PACK in $(VIM_PACK_NAMES); do \
	  for PLUGIN in $(VIM_PACK)/$$PACK/start/*; do \
	    [ -d $$PLUGIN/doc ] && ARGS="helptags $$PLUGIN/doc | $$ARGS"; \
	  done; \
	done; \
	nvim -u NONE -e -c "$$ARGS quitall" > /dev/null


## Fish ##

FISH = $(HOME)/.config/fish
BASS = $(FISH)/functions/bass.fish $(FISH)/functions/__bass.py

fish: $(BASS)

$(BASS) &:
	[ -d $(@D) ] || mkdir -p $(@D)
	git -C /tmp clone https://github.com/edc/bass.git
	cd /tmp/bass && make install
	rm -rf /tmp/bass


## Themes ##

theme:
	$(MAKE) -C theme

theme-install-tools:
	$(MAKE) -C theme install-tools


## Clean Up ##

clean:
	rm -f $(TARGET_FILES) $(THEME_TARGET_FILES)
	rm -f $(BASS)
	rm -rf $(VIM_PACK_NAMES:%=$(VIM_PACK)/%)


## Symlink Creation ##

# The generated files may not exist yet.
# Allow the symlinks to be created even with the missing source files.
theme/generated/%: ;

$(HOME)/.config/nvim/init.vim: vimrc

.SECONDEXPANSION:

# Use the basename when no explicit source mapping is declared above.
$(TARGET_FILES): $$(if $$<,,$$(patsubst .%,%,$$(@F)))
$(THEME_TARGET_FILES): \
	$$(or \
	  $$(wildcard theme/static/$$(patsubst .%,%,$$(@F))),\
	  theme/generated/$$(patsubst .%,%,$$(@F)))

$(TARGET_FILES) $(THEME_TARGET_FILES):
	[ -d $(@D) ] || mkdir -p $(@D)
	ln -s $(CURDIR)/$< $@
