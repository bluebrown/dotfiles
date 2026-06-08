set nocompatible
set noerrorbells
set encoding=utf-8
set hidden

if has('syntax')
  syntax on
endif

set nobackup nowritebackup noswapfile
if has('persistent_undo')
  set undofile undodir=~/.local/state/vim/undo
endif

filetype plugin indent on
set autoindent expandtab
set softtabstop=2 shiftwidth=2 shiftround
set backspace=indent,eol,start

set splitbelow splitright

set incsearch hlsearch ignorecase smartcase wrapscan

set termguicolors
set notitle
set number relativenumber ruler scrolloff=8
set list listchars=tab:\|\ ,trail:▫
set report=0
set foldcolumn=2
set laststatus=2 display=lastline
set showmode showcmd

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

if (has("autocmd"))
  " trim trailing whitespace
  au BufWritePre * %s/\s\+$//e
  " Remember cursor position in files
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if !empty(glob("~/.vim/pack/appearance/opt/onedark.vim"))
  packadd onedark.vim
  colo onedark
endif

hi Normal ctermbg=NONE guibg=NONE
hi StatusLine ctermbg=NONE guibg=NONE
hi StatusLineNC ctermbg=NONE guibg=NONE
