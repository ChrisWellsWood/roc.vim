" Only load this indent file when no other was loaded.
if exists('b:did_indent')
	finish
endif
let b:did_indent = 1

" Local defaults
setlocal expandtab
setlocal indentexpr=GetRocIndent()
setlocal indentkeys+=0=else,0=if,0=is,0=app,0=then,0},0\],0),0\|
setlocal nolisp
setlocal nosmartindent

" Comment formatting
setlocal comments=s1fl:#

" Only define the function once.
if exists('*GetRocIndent')
	finish
endif

" Indent pairs
function! s:FindPair(pstart, pmid, pend)
	"call search(a:pend, 'bW')
	return indent(searchpair(a:pstart, a:pmid, a:pend, 'bWn', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"'))
endfunction

function! GetRocIndent()
	let l:lnum = v:lnum - 1

	" Ident 0 if the first line of the file:
	if l:lnum == 0
		return 0
	endif

	let l:ind = indent(l:lnum)
	let l:lline = getline(l:lnum)
	let l:line = getline(v:lnum)

	" Indent if current line begins with '}':
	if l:line =~? '^\s*}'
		return s:FindPair('{', '', '}')

	" Indent if current line begins with 'else':
	elseif l:line =~# '^\s*else\>'
		if l:lline !~# '^\s*\(if\|then\)\>'
			return s:FindPair('\<if\>', '', '\<else\>')
		endif

	" Indent if current line begins with 'then':
	elseif l:line =~# '^\s*then\>'
		if l:lline !~# '^\s*\(if\|else\)\>'
			return s:FindPair('\<if\>', '', '\<then\>')
		endif

	" HACK: Indent lines in when with nearest when clause:
	elseif l:line =~# '->' && l:line !~# ':' && l:line !~# '\\'
		return indent(search('^\s*when', 'bWn')) + &shiftwidth

	" HACK: Don't change the indentation if the last line is a comment.
	elseif l:lline =~# '^\s*#'
		return l:ind

	endif

	" Add a 'shiftwidth' after lines ending with:
	if l:lline =~# '\(|\|=\|->\|<-\|(\|\[\|{\|\<\(is\|else\|if\|then\)\)\s*$'
		let l:ind = l:ind + &shiftwidth

	" Ident some operators if there aren't any starting the last line.
	elseif l:line =~# '^\s*\(!\|&\|(\|`\|+\||\|{\|[\|,\)=' && l:lline !~# '^\s*\(!\|&\|(\|`\|+\||\|{\|[\|,\)=' && l:lline !~# '^\s*$'
		let l:ind = l:ind + &shiftwidth

	elseif l:lline ==# '' && getline(l:lnum - 1) !=# ''
		let l:ind = indent(search('^\s*\S+', 'bWn'))

	endif

	return l:ind
endfunc
