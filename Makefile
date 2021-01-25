DOT_FILES = .bash_profile \
						.dir_colors \
						.gitconfig \
						.pylintrc \
						.tmux.conf \
						.tmuxline.conf \
						.vim/vimrc \
						.vim/maddn.vim \
						.vim/colors/maddn.vim \
						.vim/pack/plugin/start/vim-airline/autoload/airline/themes/maddn_airline.vim \
						.config/fish/config.fish \
						.config/fish/fish_variables \
						.config/fish/functions/fish_default_mode_prompt.fish \
						.config/fish/functions/fish_mode_prompt.fish \
						.config/fish/functions/fish_prompt.fish \
						.config/vifm/vifmrc \
						.config/vifm/colors/maddn.vifm
TARGET_FILES = $(DOT_FILES:%=$(HOME)/%)

all: vim $(TARGET_FILES) fish


## Vim ##

VIM_PACK = $(HOME)/.vim/pack
VIM_PACK_NAMES = plugin syntax tmux

vim: $(VIM_PACK_NAMES:%=$(VIM_PACK)/%/start) vim-helptags

$(VIM_PACK)/plugin/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/vim-airline/vim-airline.git
	git -C $@ clone https://github.com/moll/vim-bbye.git
	git -C $@ clone https://github.com/tpope/vim-fugitive.git
	git -C $@ clone https://github.com/airblade/vim-gitgutter.git
	git -C $@ clone https://github.com/preservim/nerdtree.git

$(VIM_PACK)/syntax/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/vim-syntastic/syntastic.git
	git -C $@ clone https://github.com/pangloss/vim-javascript.git
	git -C $@ clone https://github.com/nathanalderson/yang.vim.git
	git -C $@ clone --recursive https://github.com/davidhalter/jedi-vim.git
	git -C $@ clone https://github.com/mxw/vim-jsx.git
	git -C $@ clone https://github.com/ternjs/tern_for_vim.git

$(VIM_PACK)/tmux/start:
	[ -d $@ ] || mkdir -p $@
	git -C $@ clone https://github.com/edkolev/tmuxline.vim.git
	git -C $@ clone https://github.com/ojroques/vim-oscyank.git
	git -C $@ clone https://github.com/christoomey/vim-tmux-navigator.git
	git -C $@ clone https://github.com/tmux-plugins/vim-tmux-focus-events.git

vim-helptags:
	for PACK in $(VIM_PACK_NAMES); do \
	  for PLUGIN in $(VIM_PACK)/$$PACK/start/*; do \
	    [ -d $$PLUGIN/doc ] && ARGS="helptags $$PLUGIN/doc | $$ARGS"; \
	  done; \
	done; \
	vim -e -c "$$ARGS quitall"


## Fish ##

FISH = $(HOME)/.config/fish
BASS = $(FISH)/functions/bass.fish $(FISH)/functions/__bass.py

fish: $(BASS) $(FISH)/iterm2_shell_integration.fish

$(BASS) &:
	[ -d $(@D) ] || mkdir -p $(@D)
	git -C /tmp clone https://github.com/edc/bass.git
	cd /tmp/bass && make install
	rm -rf /tmp/bass

$(FISH)/iterm2_shell_integration.fish:
	[ -d $(@D) ] || mkdir -p $(@D)
	curl -L https://iterm2.com/shell_integration/fish -o $@


clean:
	rm -f $(TARGET_FILES)
	rm -f $(FISH)/iterm2_shell_integration.fish $(BASS)
	rm -rf $(VIM_PACK_NAMES:%=$(VIM_PACK)/%)


.SECONDEXPANSION:

$(TARGET_FILES): $$(patsubst .%,%,$$(@F))
	[ -d $(@D) ] || mkdir -p $(@D)
	ln -s $(CURDIR)/$< $@
