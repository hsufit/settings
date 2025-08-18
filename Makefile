
USERSETTINGSAVEPATH = ./userSettings/

USERSETTINGS = vimrc gitconfig inputrc
TARGET = $(USERSETTINGS:%=~/.%)

#add to avoid file in same name
.PHONY: $(USERSETTINGS)
.PHONY: $(TARGET)

all: $(TARGET)

#$@ means target
#$< means first prerequest
$(TARGET): $(addprefix $(USERSETTINGSAVEPATH)/, $(subst .,, $(notdir $@)))
	@TMP_PATH=$(realpath $(addprefix $(USERSETTINGSAVEPATH)/, $(subst .,, $(notdir $@)))); \
	if [ -e $@ ]; then \
		echo "$@ already exists, skipping..."; \
	else \
		echo "creating $@"; \
		ln -s $$TMP_PATH $@; \
	fi

clean:
	@for f in $(TARGET); do \
		if [ -L "$$f" ]; then \
			echo "remove softlink file $$f"; \
			rm "$$f"; \
		else \
			echo "$$f is not softlink file or not exist, skipped..."; \
		fi; \
	done


