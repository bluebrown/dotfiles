" basic config
filetype plugin indent on
syntax on
set encoding=utf-8
set nobackup nowritebackup noswapfile
set undofile undodir=~/.local/state/vim/undo
set nocompatible
set hidden
set noerrorbells

" better perf
set ttyfast lazyredraw
set synmaxcol=1000

" sane indents
set autoindent expandtab
set softtabstop=2 shiftwidth=2 shiftround
set backspace=indent,eol,start

" better splits
set splitbelow splitright

" better search
set incsearch hlsearch ignorecase smartcase wrapscan

" visuals
set termguicolors
set notitle
set number relativenumber ruler scrolloff=8
set list listchars=tab:\|\ ,trail:▫
set report=0
set foldcolumn=2
set laststatus=2 display=lastline
set showmode showcmd
let &t_SI = "\e[6 q"      " line cursor in insert mode
let &t_EI = "\e[2 q"      " block cursor everywhere else
let &t_SR = "\<esc>[4 q"  " underline in replace mode

" correct typos
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

" add some auto commands, if possible
if (has("autocmd"))
  " trim trailing whitespace
  au BufWritePre * %s/\s\+$//e
  " Remember cursor position in files
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" use the one dark theme, if it exsits
if !empty(glob("~/.vim/pack/appearance/opt/onedark.vim"))
  packadd onedark.vim
  colo onedark
endif

" " colors
hi Normal ctermbg=NONE guibg=NONE
hi StatusLine ctermbg=NONE guibg=NONE
hi StatusLineNC ctermbg=NONE guibg=NONE

" status line
hi link StatusERROR Error
hi link StatusNORMAL StatusLine
hi link StatusCOMMAND WildMenu
hi link StatusINSERT DiffAdd
hi link StatusVISUAL Search
hi link StatusVLINE Search
hi link StatusVBLOCK Search
hi link StatusREPLACE DiffDelete
hi link StatusRVISUAL DiffDelete

" Status Line tom
let g:_slm={
    \ 'n'       : 'NORMAL',
    \ 'no'      : 'NORMALPENDING',
    \ 'v'       : 'VISUAL',
    \ 'V'       : 'VLINE',
    \ "\<C-v>"  : 'VBLOCK',
    \ 's'       : 'SELECT',
    \ 'S'       : 'SLINE',
    \ "\<C-s>"  : 'SBLOCK',
    \ 'i'       : 'INSERT',
    \ 'R'       : 'REPLACE',
    \ 'Rv'      : 'RVISUAL',
    \ 'c'       : 'COMMAND',
    \ 'cv'      : 'EXV',
    \ 'ce'      : 'EX',
    \ 'r'       : 'PROMPT',
    \ 'rm'      : 'MORE',
    \ 'r?'      : 'CONFIRM',
    \ '!'       : 'SHELL',
    \ 't'       : 'TERM'
\}

function! ModeText()
  return get(g:_slm, mode(), "Unkown: " .. mode())
endfunction

function! ModeColor()
  return '%#Status' ..get(g:_slm, mode(), 'ERROR') .. '#'
endfunction

function! MyStatusline()
  let s = ' %f %m %r %=%l:%c %p%% %y %{&fileencoding?&fileencoding:&encoding} [%{&fileformat}] '
  if g:statusline_winid == win_getid(winnr())
    return ModeColor() .. " " .. ModeText() .. ' %#StatusLine#' .. s
  else
    return "%#StatusLineNC# " .. ModeText()  .. " " ..  s
  endif
endfunction

set noshowmode laststatus=2
set statusline=%!MyStatusline()

" WIP

" ff is aliased to `fd --type f --hidden --exclude .git --print0 | fzf-tmux -p -- --read0 --print0 --exit-0 | xargs -r -0 -o ${EDITOR:-vim}'

" fuzzy finder
function! FindFuzzy(dir)
  :execute "!fd --type f " . a:dir . " | fzf-tmux"
endfunction

:command! -nargs=1 FindFuzzy :call FindFuzzy(<q-args>)

