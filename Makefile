DOT_FILES = \
	.alacritty.yml \
	.bash_profile \
	.dircolors \
	.gitconfig \
	.pylintrc \
	.tmux.conf \
	.tmuxline.conf \
	.config/fish/config.fish \
	.config/fish/fish_variables \
	.config/fish/functions/fish_default_mode_prompt.fish \
	.config/fish/functions/fish_mode_prompt.fish \
	.config/fish/functions/fish_prompt.fish \
	.config/pygments/maddn.py \
	.config/vifm/vifmrc \
	.config/vifm/colors/maddn.vifm

ifeq (, $(shell which nvim))
VIM_PACK = $(HOME)/.vim/pack
DOT_FILES += \
	.vim/vimrc \
	.vim/colors/maddn.vim \
	.vim/pack/plugin/start/vim-airline/autoload/airline/themes/maddn_airline.vim
else
VIM_PACK = $(HOME)/.local/share/nvim/site/pack
DOT_FILES += \
	.config/nvim/init.vim \
	.config/nvim/colors/maddn.vim \
	.local/share/nvim/site/pack/plugin/start/vim-airline/autoload/airline/themes/maddn_airline.vim
endif

TARGET_FILES = $(DOT_FILES:%=$(HOME)/%)


all: vim $(TARGET_FILES) fish vim-helptags


## Vim ##

VIM_PACK_NAMES = plugin syntax tmux

vim: $(VIM_PACK_NAMES:%=$(VIM_PACK)/%/start)

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
	command -v vim && vim -e -c "$$ARGS quitall" > /dev/null


## Fish ##

FISH = $(HOME)/.config/fish
BASS = $(FISH)/functions/bass.fish $(FISH)/functions/__bass.py

fish: $(BASS)

$(BASS) &:
	[ -d $(@D) ] || mkdir -p $(@D)
	git -C /tmp clone https://github.com/edc/bass.git
	cd /tmp/bass && make install
	rm -rf /tmp/bass


clean:
	rm -f $(TARGET_FILES)
	rm -f $(BASS)
	rm -rf $(VIM_PACK_NAMES:%=$(VIM_PACK)/%)


.SECONDEXPANSION:

$(TARGET_FILES): $$(patsubst init.vim,vimrc,$$(patsubst .%,%,$$(@F)))
	[ -d $(@D) ] || mkdir -p $(@D)
	ln -s $(CURDIR)/$< $@
