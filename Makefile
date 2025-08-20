
USERSETTINGSAVEPATH = ./userSettings/

USERSETTINGS = vimrc gitconfig inputrc tigrc tmux.conf bash_aliases
TARGET = $(USERSETTINGS:%=~/.%)

GIT_PROMPT = $(realpath ./otherSourceFiles/git/git-prompt)
MARKER := \#git-prompt_marker
BASHRC = ~/.bashrc

#add to avoid file in same name
.PHONY: $(USERSETTINGS)
.PHONY: $(TARGET)
.PHONY: ~/.bashrc cleanbash

all: $(TARGET) ~/.bashrc

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

clean: cleanbash
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
