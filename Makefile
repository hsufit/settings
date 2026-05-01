
USERSETTINGSAVEPATH = ./userSettings/

USERSETTINGS = vimrc gitconfig inputrc tigrc tmux.conf bash_aliases
TARGET = $(USERSETTINGS:%=~/.%)

GIT_PROMPT = $(realpath ./otherSourceFiles/git/git-prompt)
TMUX_COMMAND_LOG = $(realpath ./otherSourceFiles/bash/tmux-command-log)
RVIM = $(realpath ./otherSourceFiles/bash/rvim)
RTERM = $(realpath ./otherSourceFiles/bash/rterm)
MARKER := \#git-prompt_marker
TMUX_COMMAND_LOG_MARKER := \#tmux-command-log_marker
RVIM_MARKER := \#rvim_marker
RTERM_MARKER := \#rterm_marker
BASHRC = ~/.bashrc

TPM_PATH := $(HOME)/.tmux/plugins/tpm

#add to avoid file in same name
.PHONY: $(USERSETTINGS)
.PHONY: $(TARGET)
.PHONY: ~/.bashrc cleanbash
.PHONY: ~/.tmux tpm tpmPlugins
.PHONY: vimPluginHint

all: $(TARGET) ~/.bashrc ~/.tmux vimPluginHint

#$@ means target
#$< means first prerequest
$(TARGET): $(addprefix $(USERSETTINGSAVEPATH)/, $(patsubst .%,%, $(notdir $@)))
	@TMP_PATH=$(realpath $(addprefix $(USERSETTINGSAVEPATH)/, $(patsubst .%,%, $(notdir $@)))); \
	if [ -e $@ ]; then \
		echo "$@ already exists, skipping..."; \
	else \
		echo "creating $@"; \
		ln -s $$TMP_PATH $@; \
	fi

~/.bashrc: $(GIT_PROMPT) $(TMUX_COMMAND_LOG) $(RVIM) $(RTERM)
	@echo "Installing Git prompt..."
	@if ! grep -q '$(MARKER)' $(BASHRC); then \
		echo "$(MARKER)" >> $(BASHRC); \
		echo "if [ -f $(GIT_PROMPT) ]; then source $(GIT_PROMPT); fi" >> $(BASHRC); \
		echo "Git prompt added to $(BASHRC)"; \
	else \
		echo "Git prompt already installed."; \
	fi
	@echo "Installing tmux command log..."
	@if ! grep -q '$(TMUX_COMMAND_LOG_MARKER)' $(BASHRC); then \
		echo "$(TMUX_COMMAND_LOG_MARKER)" >> $(BASHRC); \
		echo "if [ -f $(TMUX_COMMAND_LOG) ]; then source $(TMUX_COMMAND_LOG); fi" >> $(BASHRC); \
		echo "tmux command log added to $(BASHRC)"; \
	else \
		echo "tmux command log already installed."; \
	fi
	@echo "Installing rvim..."
	@if ! grep -q '$(RVIM_MARKER)' $(BASHRC); then \
		echo "$(RVIM_MARKER)" >> $(BASHRC); \
		echo "if [ -f $(RVIM) ]; then source $(RVIM); fi" >> $(BASHRC); \
		echo "rvim added to $(BASHRC)"; \
	else \
		echo "rvim already installed."; \
	fi
	@echo "Installing rterm..."
	@if ! grep -q '$(RTERM_MARKER)' $(BASHRC); then \
		echo "$(RTERM_MARKER)" >> $(BASHRC); \
		echo "if [ -f $(RTERM) ]; then source $(RTERM); fi" >> $(BASHRC); \
		echo "rterm added to $(BASHRC)"; \
	else \
		echo "rterm already installed."; \
	fi

vimPluginHint:
	@echo "Vim plugins are managed by Vundle."
	@echo "After make finishes, run: vim -Nu ~/.vimrc -n '+PluginInstall' '+qall'"

tpm: ~/.tmux.conf
	@if [ ! -d "$(TPM_PATH)" ]; then \
		echo "Cloning TPM..."; \
		git clone https://github.com/tmux-plugins/tpm $(TPM_PATH); \
	else \
		echo "TPM already installed."; \
	fi

tpmPlugins: tpm
	@echo "Installing tmux plugins..."
	$(TPM_PATH)/bin/install_plugins
	@echo "Updating tmux plugins..."
	$(TPM_PATH)/bin/update_plugins all
	@if tmux info >/dev/null 2>&1; then \
		echo "Reloading tmux config..."; \
		tmux source-file ~/.tmux.conf; \
	else \
		echo "No tmux server running; skipping tmux config reload."; \
	fi

~/.tmux: tpmPlugins

clean: cleanbash cleantmuxPlugin
	@for f in $(TARGET); do \
		if [ -L "$$f" ]; then \
			echo "remove softlink file $$f"; \
			rm "$$f"; \
		else \
			echo "$$f is not softlink file or not exist, skipped..."; \
		fi; \
	done

cleanbash:
	@echo "Removing Git prompt..."
	@sed -i "/$(MARKER)/,+1d" $(BASHRC)
	@echo "Git prompt removed."
	@echo "Removing tmux command log..."
	@sed -i "/$(TMUX_COMMAND_LOG_MARKER)/,+1d" $(BASHRC)
	@echo "tmux command log removed."
	@echo "Removing rvim..."
	@sed -i "/$(RVIM_MARKER)/,+1d" $(BASHRC)
	@echo "rvim removed."
	@echo "Removing rterm..."
	@sed -i "/$(RTERM_MARKER)/,+1d" $(BASHRC)
	@echo "rterm removed."

cleantmuxPlugin:
	@echo "Removing tmux plugins..."
	@rm -rf ~/.tmux/plugins
	@echo "Tmux plugins removed."
