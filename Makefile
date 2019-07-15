all: vimrc gitGlobalconfig inputrc

vimrc: ~/.vimrc
	cp ~/.vimrc ./vimrc

gitGlobalconfig: ~/.gitconfig
	cp ~/.gitconfig ./gitconfig

inputrc: ~/.inputrc
	cp ~/.inputrc ./inputrc


