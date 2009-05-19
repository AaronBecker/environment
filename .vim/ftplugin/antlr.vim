" Vim filetype plugin file
" Language:	Antlr

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

" Set 'comments' to format dashed lists in comments. Behaves just like C.
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/

setlocal commentstring=//%s

" Undo the stuff we changed.
let b:undo_ftplugin = " formatoptions< comments< commentstring< path< includeexpr<"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
