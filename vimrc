""""""""""""""""""""""""""""""""""Kevin's .vimrc""""""""""""""""""""""""""""""""""""""""""
"OS     Ubuntu 10.04
"VIM    Vi IMproved 7.2 (2008 Aug 9, compiled Apr 16 2010 12:40:58)
"Ctags  Exuberant Ctags 5.8, Compiled: Mar  6 2010, 15:35:10
"       Optional compiled features: +wildcards, +regex
"Author ykrocku at gmail dot com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"运行环境检测
function! IsGvim()
	if has("gui_running")
	    return 1
	else
	    return 0
	endif
endfunction
function! IsWindows()
	if has("win32")
	    return 1
	else
	    return 0
	endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"启用非兼容模式
set nocompatible
"保存400个命令历史
set history=400
"开启文件类型检测
filetype plugin on
"显示/隐藏行号 number/nonumber(nu/nonu)
set number
"设置文件编码检查顺序
if IsWindows()
	set fileencodings=gb2312,utf8,latin1
else
	set fileencodings=utf8,gb2312,latin1
endif
"设置快捷键开始字符
let mapleader=","
"设置不自动换行
set nowrap
"设置增量搜索
set incsearch
"设置文件备份
"set backup
"set backupext=.bak
"设置自动隐藏缓冲区，在tag跳转时非常有用，不会再提示文件未保存
set hidden
"在normal模式下启用鼠标（可以用来改变窗口的大小）
set mouse=n
set splitright
set splitbelow
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Session和Viminfo相关
"set sessionoptions+=
nmap <leader>sp :call SaveProject()<CR>
nmap <leader>lp :call LoadProject()<CR>
function! LoadProject()
	cd %:h          "切换vim到PWD到当前目录(并设置其为工程起始目录)
	let g:prj_dir=expand("%:p:h")
	so session.vim
	rviminfo viminfo.vim
	exe 'syntax enable'
	"TODO taglist window not restored properly(set background=dark caused "this)
endfunction
au VimEnter 0_0_project call LoadProject()

function! SaveProject()
	"TODO 切换回工程起始目录(可能手动执行了cd到其他目录)
	mksession! session.vim
	wviminfo! viminfo.vim
	echo "Write session done!"
	exe "qall"
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"状态栏设置
set laststatus=2
set statusline=#%n\|\%f%m%r%h\|\%{CurDir()}\|\%p%%\|\%c.%l/%L\|\%=%<\|\Ascii=%b,Hex=0x%B%{((&fenc==\"\")?\"\":\"\|\".&fenc)}\|ts=%{&ts}:sw=%{&sw}:et=%{&et}
function! CurDir()
	let curdir = substitute(getcwd(), $HOME, "~", "g")
	return curdir
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"代码折叠相关
"启用/停用折叠 foldenable/nofoldenable(fen/nofen)
"set foldenable
set nofoldenable
"代码折叠方式选择 foldmethod(fdm)
set foldmethod=syntax
"高亮匹配括号
set showmatch
"获取更多相关信息可执行help fold.txt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"开启自动缩进（只设置cindent也可以很好的工作，autoindent好像没有很多必要）
set autoindent
"设置使用>,<,=命令格式化代码时也是使用4个空格
set shiftwidth=4
"代码缩进方式：使用4个空格缩进。
function! CodingStyleInit()
	"开启c语言缩进
	setl cindent
	"启用/停用空格替换tab expandtab/noexpandtab (et/noet)
	setl expandtab
	"设置在插入模式时，按tab键也是4个空格
	setl tabstop=4
    setl softtabstop=4
endfunction
autocmd! filetype c,cpp,markdown,python call CodingStyleInit()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"着色相关
"开启语法高亮
syntax enable 
"开启/关闭搜索高亮 hlsearch/nohlsearch(hls/nohls)
set hlsearch
"配色主题
colo evening
highlight StatusLine cterm=bold ctermfg=darkred ctermbg=white guifg=darkblue guibg=olivedrab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"快捷键映射
"用空格来翻页
map <space> <C-F>
map <backspace> <C-B>

"使用F12键切换窗口
map <F12> <C-w>w
map <S-F12> <C-w>W
"使用左右键切换当前编辑文件
map <C-right> :bn<CR>
map <C-left> :bp<CR>
nmap <silent> <leader>s :w<CR>
nmap <silent> <leader>ss :wall<CR>
nmap <silent> <leader>qq :q<CR>
nmap <silent> <leader>qa :qall<CR>
nmap <silent> <leader>wm 100<C-W>+
nmap <silent> <leader>wn 100<C-W>-
"小键盘的+-键来折叠代码
map <kPlus> zo
map <kMinus> zc
if IsWindows()
	map <silent> <leader>sv :source $HOME/_vimrc<CR>
	map <silent> <leader>snp :split $HOME/_vim/snippets/c.snippets<CR>
	map <silent> <leader>ex :!notepad %<CR>
	autocmd! bufwritepost *vimrc source $HOME/_vimrc
else
	map <silent> <leader>sv :source $HOME/.vimrc<CR>
	map <silent> <leader>snp :split $HOME/.vim/snippets/c.snippets<CR>
	map <silent> <leader>ex :!gedst %<CR>
	autocmd! bufwritepost *vimrc source $HOME/.vimrc
endif
"ESC最常用，但是也是最远的键，这可能是vimer最痛苦的事
inoremap ,, <esc>
"打开quick fix窗口
imap <F9> <ESC>:copen<CR>
map <silent> <F9> :copen<CR>
"ubuntu10.04中，F10是弹出主菜单的快捷键，所以需要隐藏菜单栏。
imap <F10> <ESC>:cn<CR>
map <silent> <F10> :cn<CR>

"自动缩进整个文档(缺点：会改变jumps列表)
map <leader>ff <esc>gg=G<C-O><C-O>
"能减少一点输入到替换
nmap <C-h> :%s/<C-R>=expand("<cword>")<CR>/
nmap <C-j> :grep --exclude-dir=.svn --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=expand("<cword>")<CR>" -rI .
nmap <C-l> :lgrep --exclude-dir=.svn --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=expand("<cword>")<CR>" -rI .
nmap <C-k> :grep --exclude-dir=.svn --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=expand("<cword>")<CR>" -rI <C-R>=expand("%:h")<CR>
nmap <C-e> :e <C-R>=expand("%:h")<CR>/
"vmap <C-h> :normal! gv"ry<CR>:%s/<C-R>=@r<CR>/
vmap <C-h> :normal! gvy<CR>:%s/<C-R>=@<CR>/
vmap <C-j> :normal! gvy<CR>:grep --exclude-dir=.svn  --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=@<CR>" -rI .
vmap <C-l> :normal! gvy<CR>:lgrep --exclude-dir=.svn  --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=@<CR>" -rI .
vmap <C-k> :normal! gvy<CR>:grep --exclude-dir=.svn  --exclude \*.o --exclude \*.swp --exclude \*.map --exclude \*.htm --exclude \*.bak "<C-R>=@<CR>" -rI <C-R>=expand("%:h")<CR>
"插入当前日期
inoremap $rq <C-R>=strftime("%Y-%m-%d")<CR>
"插入当前编辑的文件名
inoremap $fn <C-R>=bufname("%")<CR>
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"高亮光标所在行1s
map <F2> :set cul<CR>:sleep 500m<CR>:set nocul<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"写代码时设置
"taglist设置
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
set updatetime=500
"在当前窗口和TagBar窗口间切换
map <F4> :call JumpToTagList()<CR>
function! JumpToTagList()
    exe 'TagbarToggle'
endfunction

"OmniCppComplete设置
"如果需要使用OmniCppComplete，需使用
"ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
"来生成tag。
let OmniCpp_SelectFirstItem = 2
inoremap <expr> <CR> pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <ESC> pumvisible()?"\<C-E>":"\<ESC>"
inoremap <expr> <C-J> pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K> pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
"输入模式下的撤销
inoremap <C-Z> <esc>ui

"ctags
if filereadable("/usr/include/tags")
	set tags=./tags,./TAGS,tags,TAGS,/usr/include/tags
endif
"cscope设置
if has("cscope")
	"set csprg=/usr/local/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
	    cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cs add $CSCOPE_DB
	endif
	if filereadable("/usr/include/cscope.out")
	    cs add /usr/include/cscope.out /usr/include
	endif
	set csverb
	"nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	"nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	"nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

	nmap <C-\>s :scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>c :scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :scs find d <C-R>=expand("<cword>")<CR><CR>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"快速启用/禁用某一特性

"高亮光标所在单词，而不滚动屏幕,Reference:(TODO:得搜索一次才生效)
"http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches
function! ToggleHlsearch()
	let pattern="\\<".expand("<cword>")."\\>"
	if pattern==@/
	    if &hls
	        set nohls
	    else
	        set hls
	    endif
	else
	    let @/=pattern
	    set hls
	endif
endfunction
map <silent>  <F8>  :call ToggleHlsearch()<CR>

function! ToggleIgnoreCase()
	if &ic
	    set noic
echo "Case Sensetive OFF"
	else
	    set ic
echo "Case Sensetive ON"
	endif
endfunction
"切换搜索大小写敏感
map <silent> <leader>ic :call ToggleIgnoreCase()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"map <F3> <C-W>}
"在预览窗口中查看并高亮光标下tag(修改自vim中文手册范例)
"http://vimcdoc.sourceforge.net/doc/windows.html#windows.txt
map <F3> :call PreviewWord()<CR>
function! GoToWindow(winnr)
	for a:i in range(bufnr("$"))  " 返回原来的窗口
	    silent! wincmd w
	    if a:winnr==winnr()
	        return
	    endif
	endfor
endfunction
function! PreviewWord()
	if &previewwindow                  " 不要在预览窗口里执行
	    return
	endif
	if exists("g:TagList_title") && g:TagList_title==bufname("%")
	    return
	endif
	let w = expand("<cword>")          " 在当前光标位置抓词
	if w =~ '\a'                       " 如果该单词包括一个字母

	let a:current_winnr=winnr()
	" 在显示下一个标签之前，删除所有现存的语法高亮
	silent! wincmd P                 " 跳转至预览窗口
	if &previewwindow                " 如果确实转到了预览窗口……
	  match none                     " 删除语法高亮
	  call GoToWindow(a:current_winnr)    " 回到原来的窗口
	endif

	" 试着显示当前光标处匹配的标签
	try
	   "exe "ptag " . w
	   exe "ptag " w
	catch
	  return
	endtry
	silent! wincmd P                 " 跳转至预览窗口
	if &previewwindow                " 如果确实转到了预览窗口……
	  if has("folding")
	    silent! .foldopen            " 展开折叠的行
	  endif
	  call search("$", "b")          " 到前一行的行尾
	  let w = substitute(w, '\\', '\\\\', "")
	  call search('\<\V' . w . '\>') " 定位光标在匹配的单词上
	  " 给在此位置的单词加上匹配高亮
	  hi previewWord term=bold ctermbg=blue guibg=green
	  exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
	  call GoToWindow(a:current_winnr)
	endif
  endif
endfunction


" vim:ts=4:sw=4:et

