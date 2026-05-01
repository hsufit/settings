
USERSETTINGSAVEPATH = ./userSettings/

USERSETTINGS = vimrc gitconfig inputrc tigrc tmux.conf bash_aliases
TARGET = $(USERSETTINGS:%=~/.%)

GIT_PROMPT = $(realpath ./otherSourceFiles/git/git-prompt)
MARKER := \#git-prompt_marker
BASHRC = ~/.bashrc

TPM_PATH := $(HOME)/.tmux/plugins/tpm

#add to avoid file in same name
.PHONY: $(USERSETTINGS)
.PHONY: $(TARGET)
.PHONY: ~/.bashrc cleanbash
.PHONY: ~/.tmux

all: $(TARGET) ~/.bashrc ~/.tmux

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

~/.bashrc: $(GIT_PROMPT)
	@echo "Installing Git prompt..."
	@if ! grep -q '$(MARKER)' $(BASHRC); then \
		echo "$(MARKER)" >> $(BASHRC); \
		echo "if [ -f $(GIT_PROMPT) ]; then source $(GIT_PROMPT); fi" >> $(BASHRC); \
		echo "Git prompt added to $(BASHRC)"; \
	else \
		echo "Git prompt already installed."; \
	fi

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

cleantmuxPlugin:
	@echo "Removing tmux plugins..."
	@rm -rf ~/.tmux/plugins
	@echo "Tmux plugins removed."
