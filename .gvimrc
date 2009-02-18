
" colorscheme twilight2 
" colorscheme desert2
" colorscheme darkspectrum
" colorscheme ir_black
colorscheme moria2
" colorscheme impact

" current line highlight
set cursorline
highlight CursorLine guibg=grey10

" much nicer font
set guifont=Monaco:h12

" 120 columns, plus 32 for NERDTree
set columns=152

if has("gui_macvim")
"    colorscheme macvim
    set gtl=%t gtt=%F " nicer tab names
endif

" auto-start nerdtree
augroup Startup
    au!
    au! VimEnter * exe 'NERDTree' | wincmd l
augroup END
