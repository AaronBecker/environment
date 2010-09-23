" Do c++ style syntax coloring for .ci interface files
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.cu set filetype=cpp
    au! BufRead,BufNewFile *.ci set filetype=ci
    au! BufRead,BufNewFile *.cj set filetype=charj
    au! BufRead,BufNewFile *.g set filetype=antlr3
    au! BufRead,BufNewFile *.stg set filetype=stringtemplate
    au! BufRead,BufNewFile *.clj set filetype=clojure
augroup END


