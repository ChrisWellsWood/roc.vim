" Keywords
syn keyword rocConditional else if is then
syn keyword rocImport app provides interface exposes imports

" Operators
syn match rocOperator contained "\([-!#$%`&\*\+./<=>\?@\\^|~:]\|\<_\>\)"

" Types
syn match rocTag "\<[A-Z][0-9A-Za-z_'-]*"

" Delimiters
syn match rocDelimiter  "[,;]"
syn match rocBraces  "[()[\]{}]"

" Functions
syn match rocFunction "\((,\+)\)"

" Comments
syn keyword rocTodo TODO FIXME XXX contained
syn match rocLineComment "#.*" contains=elmTodo,@spell

" Strings
syntax region rocString start=/"/ skip=/\\"/ end=/"/ oneline contains=rocInterpolatedWrapper
syntax region rocInterpolatedWrapper start="\v\\\(\s*" end="\v\s*\)" contained containedin=rocString contains=rocInterpolatedString
syntax match rocInterpolatedString "\v\w+(\(\))?" contained containedin=rocInterpolatedWrapper

" Numbers
syntax match rocNumber "\v<\d+>"
syntax match rocNumber "\v<\d+\.\d+>"
syntax match rocNumber "\v<0x\x+([Pp]-?)?\x+>"
syntax match rocNumber "\v<0b[01]+>"
syntax match rocNumber "\v<0o\o+>"

" Identifiers
syn match rocTopLevelDecl "^\s*[a-zA-Z][a-zA-z0-9_]*\('\)*\s\+:\(\r\n\|\r\|\n\|\s\)\+" contains=rocOperator
syn match rocFuncName /^\l\w*/

" Folding
syn region rocTopLevelTypedef start="type" end="\n\(\n\n\)\@=" contains=ALL fold
syn region rocTopLevelFunction start="^[a-zA-Z].\+\n[a-zA-Z].\+=" end="^\(\n\+\)\@=" contains=ALL fold
syn region rocWhenBlock matchgroup=rocWhenBlockDefinition start="^\z\(\s\+\)\<when\>" end="^\z1\@!\W\@=" end="\(\n\n\z1\@!\)\@=" end="\n\z1\@!\(\n\n\)\@=" contains=ALL fold
syn region rocWhenItemBlock start="^\z\(\s\+\).\+->$" end="^\z1\@!\W\@=" end="\(\n\n\z1\@!\)\@=" end="\(\n\z1\S\)\@=" contains=ALL fold

hi def link rocFuncName Function
hi def link rocWhenBlockDefinition Conditional
hi def link rocWhenBlockItemDefinition Conditional
hi def link rocTopLevelDecl Function
hi def link rocFunction Normal
hi def link rocTodo Todo
hi def link rocLineComment Comment
hi def link rocString String
hi def link rocInterpolatedWrapper Delimiter
hi def link rocNumber Number
hi def link rocDelimiter Delimiter
hi def link rocBraces Delimiter
hi def link rocImport Include
hi def link rocConditional Conditional
hi def link rocOperator Operator
hi def link rocTag Identifier
