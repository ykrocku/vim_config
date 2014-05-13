
all:
	@cp -uv vimrc ~/.vimrc
	@cp -uvr vim/. ~/.vim

clean:
	rm ~/.vimrc -rf
	rm ~/.vim -rf
