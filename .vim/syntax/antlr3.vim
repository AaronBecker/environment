" vim: ts=8
" Vim syntax file
" Language:     ANTLRv3
" Maintainer:   Jörn Horstmann (updated by Davyd Madeley)
" Last Change:  2008-11-21

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" String, constant, and comment rules stolen gratuitously from java.vim
syn match   antlrSpecialError     contained "\\."
syn match   antlrSpecialCharError contained "[^']"
syn match   antlrSpecialChar      contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\+\x\{4\}\)"
syn region  antlrString		  start=+"+ end=+"+ end=+$+ contains=antlrSpecialChar,antlrSpecialError
syn region  antlrString		  start=+'+ end=+'+ end=+$+ contains=antlrSpecialChar,antlrSpecialError
syn match   antlrNumber		  "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   antlrNumber		  "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   antlrNumber		  "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   antlrNumber		  "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

syn region  antlrComment          start="/\*" end="\*/"
syn match   antlrComment          "/\*\*/"
syn match   antlrComment          "//.*$"
syn keyword antlrTodo		  contained TODO FIXME XXX
syn region  antlrCommentString    contained start=+"+ end=+"+ end=+$+ end=+\*/+me=s-1,he=s-1 contains=antlrSpecial,antlrCommentStar,antlrSpecialChar
syn region  antlrComment2String   contained start=+"+  end=+$\|"+  contains=antlrSpecial,antlrSpecialChar
syn match   antlrCommentCharacter contained "'\\[^']\{1,6\}'" contains=antlrSpecialChar
syn match   antlrCommentCharacter contained "'\\''" contains=antlrSpecialChar
syn match   antlrCommentCharacter contained "'[^\\]'"
syn cluster antlrCommentSpecial   add=antlrCommentString,antlrCommentCharacter,antlrNumber
syn cluster antlrCommentSpecial2  add=antlrComment2String,antlrCommentCharacter,antlrNumber
syn region  antlrComment	  start="/\*"  end="\*/" contains=@antlrCommentSpecial,antlrTodo
syn match   antlrCommentStar      contained "^\s*\*[^/]"me=e-1
syn match   antlrCommentStar      contained "^\s*\*$"
syn match   antlrLineComment      "//.*" contains=@antlrCommentSpecial2,antlrTodo

syn keyword antlrKeyword grammar lexer parser tree header members fragment returns throws scope init rulecatch
syn keyword antlrKeyword tokens nextgroup=antlrTokens skipwhite
syn keyword antlrKeyword options nextgroup=antlrOptions skipwhite

syn match antlrToken         "\<[A-Z_][a-zA-Z_0-9]\+\>"
syn match antlrRule          "^[a-z][a-zA-Z_0-9]\+"
syn match antlrSigilVariable "$[a-zA-Z][a-zA-Z0-9]*"

syn match antlrOperator "[:;@.]"
syn match antlrOperator "[()]"
syn match antlrOperator "[?+*~|!]"
syn match antlrOperator "[->=^]"
syn match antlrBrace "[\[\]{}]"

syn region antlrTokens start='{' end='}' contains=antlrString,antlrToken,antlrOperator,antlrComment
syn region antlrOptions start='{' end='}' contains=antlrString,antlrOperator,antlrComment
syn include @Java syntax/java.vim
"syn region antlrAction matchgroup=antlrBrace start="[{\[]" end="[}\]]" contains=antlrSigilVariable,antlrString,@Java
syn region antlrAction matchgroup=antlrBrace start="[{\[]" end="[}\]]" contains=antlrSigilVariable,antlrString,@Java

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508
  if version < 508
    let did_antlr_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink antlrString            String
  hi def antlrVariable          term=bold cterm=bold gui=bold
  HiLink antlrBrace             Operator
  HiLink antlrComment           Comment
  HiLink antlrLineComment       Comment
  HiLink antlrOperator          Operator
  HiLink antlrKeyword           Keyword
  HiLink antlrToken             PreProc
  HiLink antlrScopeVariable     Identifier
  HiLink antlrSigilVariable     Identifier
  HiLink antlrRule              Type
  HiLink antlrTodo		Todo
  delcommand HiLink
endif

let b:current_syntax = "antlr3"

