" Do c++ style syntax coloring for .ci interface files
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.ci     setfiletype cpp
augroup END
