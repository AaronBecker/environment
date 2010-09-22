set nocompatible    " screw vi

" windows systems only
"source $VIMRUNTIME/mswin.vim
"behave mswin

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin on

" backup and swap files
set backspace=2    " allow backspacing over everything in insert mode
set writebackup
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set backup
"set nobackup

set viminfo='20,\"250   " read/write a .viminfo file, don't store more than
                        " 250 lines of registers
set history=250         " keep 250 lines of command line history
set ruler               " show the cursor position all the time


" tabbing sanity
set autoindent
filetype indent on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=0         " Don't wrap words by default

" search options
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase           " case insensitive matching, unless you use caps
set gdefault            " search global by default
set incsearch           " Incremental search
set nohlsearch          " don't highlight search

"set relativenumber      " show line numbers relative to cursor location
set nonumber
set scrolloff=3         " keep some context around the cursor
set noerrorbells        " no noises, thanks
set vb
set showmode
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set laststatus=2
set autowrite           " Automatically save before commands
                        " like :next and :make
set hidden              " allow modified hidden buffers
set ttyfast             " Yeah, this terminal is pretty fast :)
set magic               " Use pattern matching symbols
set wildmenu
set wildmode=list:longest   " bash style completion
set listchars=trail:·   " show trailing whitespace
" get things looking nice
syntax on

set background=dark
colorscheme vividchalk
set nohlsearch

" autosave when we lose focus
au FocusLost * :wa

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.class,.pyc,.decl.h,.def.h

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" autosave when we lose focus
au FocusLost * :wa

" Make j and k go by visible lines instead of logical lines
nmap j gj
nmap k gk
" Add some extra navigation keys
noremap <space> <C-d>
noremap <C-space> <C-u>

" Detect filetypes
augroup filetype
    au!
    au! BufRead,BufNewFile *.cu set filetype=cpp
    au! BufRead,BufNewFile *.ci set filetype=ci
    au! BufRead,BufNewFile *.cj set filetype=charj
    au! BufRead,BufNewFile *.g set filetype=antlr3
    au! BufRead,BufNewFile *.stg set filetype=stringtemplate
    au! BufRead,BufNewFile *.clj set filetype=clojure
augroup END


" ignore swap files unless I restore manually
augroup swap_clobber
    au!
    au SwapExists * let v:swapchoice='e'
augroup END

" TagList
nnoremap <silent> <F5> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1     " exit if taglist is last window open

" Fuzzy file search
map <leader>f :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
let g:fuzzy_ignore = "*.o"
command FuzzyFinderClear :ruby @finder = nil

" NERDTree
map <leader>n :NERDTreeToggle<CR>

let g:proj_flags="gimsvt"
nmap <silent> <Leader>p <Plug>ToggleProject

let python_highlight_all=1

" Remove trailing whitespace
function TrimWhiteSpace()
  %s/\s*$//
  ''
:endfunction
map <Leader>W :call TrimWhiteSpace()<CR>

" Neat paren coloring
augroup rainbow
    au!
    au! VimEnter * exe 'RainbowParenthesesToggle' | wincmd l
augroup END

