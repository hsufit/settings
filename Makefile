all: vimrc gitGlobalconfig

vimrc: ~/.vimrc
	cp ~/.vimrc ./vimrc

gitGlobalconfig: ~/.gitconfig
	cp ~/.gitconfig ./gitconfig





