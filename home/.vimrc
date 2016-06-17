set nocompatible
set encoding=utf-8

"" ruby/dyn {{{
if has('ruby')
  let s:ruby_libruby = system("ruby -rrbconfig -e 'print File.join(RbConfig::CONFIG[\"libdir\"], RbConfig::CONFIG[\"LIBRUBY\"])'")
  if filereadable(s:ruby_libruby)
    let $RUBY_DLL = s:ruby_libruby
  endif
endif
"" }}}

set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }

NeoBundle 'Shougo/vimshell.vim'

NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'mrkn/mrkn256.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'motemen/git-vim'
" NeoBundle 'mileszs/ack.vim'
" NeoBundle 'rking/ag.vim'
NeoBundle 'thinca/vim-quickrun'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'sgur/unite-git_grep'
NeoBundle 'taka84u9/unite-git'

NeoBundle 'thinca/vim-ref'
NeoBundle 'taka84u9/vim-ref-ri'
NeoBundle 'rizzatti/funcoo.vim'
NeoBundle 'rizzatti/dash.vim'

NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'osyo-manga/vim-over'

NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-haml'
NeoBundle 'slim-template/vim-slim'

NeoBundle 'kana/vim-tabpagecd'

NeoBundle 'mrkn/vim-cruby'

NeoBundle 'itspriddle/vim-marked'

NeoBundle 'info.vim'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'

NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'keith/rspec.vim'

NeoBundle 'JuliaLang/julia-vim'

NeoBundle 'derekwyatt/vim-scala'

NeoBundle 'wakatime/vim-wakatime'

call neobundle#end()

filetype plugin indent on
syntax on

set backspace=indent,eol,start
set history=1000
set showcmd
set showmode
set incsearch
set hlsearch
set number
set ruler
set title
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~
set novisualbell
set noerrorbells
set pastetoggle=<F2>
set showbreak=...
set wrap
set linebreak
set list
set listchars=eol:$,tab:>-
set hidden
set autoindent
set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab

set cmdheight=2
set laststatus=2
set display=lastline

set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

" backup setting
if !isdirectory($HOME . '/.vim/backup')
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" swapfile setting
if !isdirectory($HOME . '/.vim/swap')
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" undofile setting
if !isdirectory($HOME . '/.vim/undo')
  :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
endif
set undodir=./.vim-undo//
set undodir+=~/.vim/undo//
set undodir+=.

"" key bindings {{{
nnoremap <silent> <Space>p  "+p
nnoremap <silent> <Space>y  "+y
nnoremap <silent> <Space>QQ  :qa!<CR>
nnoremap <silent> <Space>qa  :qa<CR>
nnoremap <silent> <Space>wq  :wq<CR>
"" }}}

"" netrw {{{
let g:netrw_liststyle=3
"" }}}

"" Neocomplete {{{
" disable AutoComplPop
let g:acp_enableAtStartup = 0

" Use neocomplete
let g:neocomplete#enable_at_startup = 1

" Use smartcase
let g:neocomplete#enable_smart_case = 1

" Set minimum syntax keyword length
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define keywrod
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings
inoremap <expr><C-g>	neocomplete#undo_completion()
inoremap <expr><C-l>	neocomplete#complete_common_string()

" Recommended key-mappings
" <CR>: close popup and save indent
inoremap <silent> <CR>	<C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion
inoremap <expr><TAB>	pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backward char.
inoremap <expr><C-h>	neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>	neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>	neocomplete#close_popup()
inoremap <expr><C-e>	neocomplete#cancel_popup()
" Close popup by <Sapce>
inoremap <expr><Space>	pumvisible() ? neocomplete#close_popup()."\<Space>" : "\<Space>"

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythonconmplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"" }}}

augroup ruby
  autocmd!
augroup END

"" cruby {{{
augroup cruby
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/work/ruby/**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,y} set filetype=cruby
augroup END
"" }}}

"" vim-indent-guides {{{
let g:indent_guides_start_level = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
augroup IndentGuides
  autocmd!
  if has("gui_running") || &t_Co == 88 || &t_Co == 256
    autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd   ctermbg=234 guibg=#333333
    autocmd VimEnter,ColorScheme * :hi IndentGuidesEven  ctermbg=235 guibg=#666666
  endif
augroup END
"" }}}

"" unite.vim {{{
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep
nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" grep a word under the cursor
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" recall the result the last grep
nnoremap <silent> ,r :<C-u>UniteResume search-buffer<CR>

nnoremap [unite] <Nop>
nmap <Leader>f [unite]

nnoremap [unite]u  :<C-u>Unite -no-split<Space>
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> ,vr :UniteResume<CR>

" vinarise
let g:vinarise_enable_auto_detect = 1

" unite-build map
nnoremap <silent> ,vb  :Unite build<CR>
nnoremap <silent> ,vcb :Unite build:!<CR>
nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>
"" }}}

"" unite-git_grep {{{
nnoremap <silent> [unite]gg :<C-u>Unite<Space>vcs_grep<CR>
"" }}}

"" netrw {{{
let g:netrw_http_cmd = "curl"
let g:netrw_http_xcmd = "-x socks5h://localhost:23921 -o"
"" }}}

"" vim-over {{{
nnoremap <silent> <Leader>m :OverCommandLine<CR>
"" }}}

"" grep {{{
if executable("hw")
  " Use hw over grep
  set grepprg=hw\ --no-group\ --no-color
  " Use hw in Ctrl-p for listing files.  Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'hw %s -l --no-color'
  " hw is fast enough that Ctrl-p doesn't need to cache
  let g:ctrlp_use_caching = 0
  " Use hw for Unite grep
  let g:unite_source_grep_command = 'hw'
  let g:unite_source_grep_default_opts = '--no-group --no-color'
  let g:unite_source_grep_recursive_opt = ''
elseif executable("ag")
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in Ctrl-p for listing files.  Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that Ctrl-p doesn't need to cache
  let g:ctrlp_use_caching = 0
  " Use ag for Unite grep
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
"" }}}

"" Kaoriya {{{
if !has('kaoriya')
  cnoremap <C-X> <C-R>=<SID>GetBufferDirectory()<CR>
  function! s:GetBufferDirectory()
    let path = expand('%:p:h')
    let cwd = getcwd()
    let dir = '.'
    if match(path, escape(cwd, '\')) != 0
      let dir = path
    elseif strlen(path) > strlen(cwd)
      let dir = strpart(path, strlen(cwd) + 1)
    endif
    return dir . (exists('+shellslash') && !&shellslash ? '\' : '/')
  endfunction
endif
"" }}}

set background=dark
colorscheme mrkn256
set secure
