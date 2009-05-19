
" colorscheme twilight2 
" colorscheme desert2
" colorscheme darkspectrum
" colorscheme ir_black
" colorscheme moria2
" colorscheme impact
" colorscheme dante
" colorscheme wombat
colorscheme vividchalk

" current line highlight
set cursorline
highlight CursorLine guibg=grey10

" don't use lousy default font
set guifont=Consolas:h15,Inconsolata:h15,DejaVu_Sans_Mono:h15,Monaco:h15

" 120 columns, plus 32 for NERDTree
set columns=152

if has("gui_macvim")
"    colorscheme macvim
    set gtl=%t gtt=%F " nicer tab names
endif

" auto-start nerdtree
"augroup Startup
"    au!
"    au! VimEnter * exe 'NERDTree' | wincmd l
"augroup END
