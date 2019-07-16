
USERSETTINGSAVEPATH = ./userSettings/

USERSETTINGS = vimrc gitconfig inputrc

#add to avoid file in same name
.PHONY: $(USERSETTINGS)

all: $(USERSETTINGS)

#TODO: find how to use prerequest
#$@ means target
#$< means first prerequest
$(USERSETTINGS): $(USERSETTINGS:%=~/.%)
	cp ~/.$@ $(USERSETTINGSAVEPATH)$@




