" 设置leader为,
let mapleader=";"
let g:mapleader=";"
set noswapfile
set nocompatible            " 关闭 vi 兼容模式
syntax on                   " 自动语法高亮

filetype plugin indent on   " 开启插件
set mouse=a                 " 支持鼠标
set autoindent              " 自动缩进"
set number                  " 显示行号
set nocursorline            " 不突出显示当前行
set shiftwidth=4            " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4           " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4               " 设定 tab 长度为 4
set nobackup                " 覆盖文件时不备份
set autochdir               " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes          " 设置备份时的行为为覆盖
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍大小写敏感
set nowrapscan              " 禁止在搜索到文件两端时重新搜索
" set incsearch               " 输入搜索内容时就显示搜索结果
set hlsearch                " 搜索时高亮显示被找到的文本
set noerrorbells            " 关闭错误信息响铃
set novisualbell            " 关闭使用可视响铃代替呼叫
set t_vb=                   " 置空错误铃声的终端代码
" set showmatch               " 插入括号时，短暂地跳转到匹配的对应括号
"set matchtime=2             " 短暂跳转到匹配括号的时间
"set nowrap                  " 不自动换行
set magic                  " 显示括号配对情况
set hidden                  " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
set smartindent             " 开启新行时使用智能自动缩进
set backspace=indent,eol,start
                            " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1             " 设定命令行的行数为 1
set laststatus=2            " 显示状态栏 (默认值为 1, 无法显示状态栏)
" set foldenable              " 开始折叠
" set foldmethod=syntax       " 设置语法折叠
" set foldcolumn=0            " 设置折叠区域的宽度
" setlocal foldlevel=1        " 设置折叠层数为
" set foldclose=all           " 设置为自动关闭折叠
colorscheme delek  " 设定配色方案
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)\
                            " 设置在状态行显示的信息
" 显示Tab符 set list
set expandtab

"设置代码折叠方式为 手工 manual  indent
set foldmethod=manual
"设置代码块折叠后显示的行数
set foldexpr=1

map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC>:NERDTreeToggle<CR>
map <F6> :BufExplorer<CR>
imap <F6> <ESC>:BufExplorer<CR>

" {{{ 编码字体设置
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8

" }}}

" {{{全文搜索选中的文字
:vmap <silent> <leader>f y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
:vmap <silent> <leader>F y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
" }}}

" 删除所有行未尾空格
nmap <F12> :%s/[ \t\r]\+$//g<CR>
" Buffers操作快捷方式!
nmap <S-L> :bnext<CR>
nmap <S-H> :bprevious<CR>

" Tab操作快捷方式!
nmap <S-J> :tabnext<CR>
nmap <S-K> :tabprev<CR>

" 插入模式下左右移动光标
" inoremap <c-l> <esc>la
" inoremap <c-h> <esc>ha

nmap <C-S> :update<CR>
vmap <C-S> <C-C>:update<CR>
imap <C-S> <C-O>:update<CR>

"窗口分割时,进行切换的按键热键需要连接两次,比如从下方窗口移动
"光标到上方窗口,需要<c-w><c-w>k,非常麻烦,现在重映射为<c-k>,切换的
"时候会变得非常方便.
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" 选中状态下 Ctrl+c 复制
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

"一些不错的映射转换语法（如果在一个文件中混合了不同语言时有用）
nmap <leader>1 :set filetype=xhtml<CR>
nmap <leader>2 :set filetype=php<CR>
nmap <leader>3 :set filetype=css<CR>
nmap <leader>4 :set filetype=sql<CR>
nmap <leader>5 :set filetype=javascript<CR>

" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python set tabstop=2 shiftwidth=2
let g:pydiction_location = '~/.vim/after/ftplugin/python-complete-dict'


let g:user_zen_leader_key = '<c-y>'

" php语法检查
" map <C-P> :!php -l %<CR>
map <C-P> :w !php -l<CR>

map <S-Left> :tabp<CR>
map <S-Right> :tabn<CR>
set guioptions-=T
" set guifont=Bitstream_Vera_Sans_Mon
set guifont=文泉驿等宽微米黑\ 12

