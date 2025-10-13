" Vim indent file
" Language:     F#
" Maintainer:   Phil Thompson        <phil@electricvisions.com>
" Created:      2020 May 04
" Last Change:
"
" Only load this indent file when no other was loaded.

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=FSharpIndent()
setlocal indentkeys+=0=\|,0=\|],0=when,0=elif,0=else,0=\|\>,==,=with

" Only define the function once
if exists("*GetFsharpIndent")
  finish
endif

" Debug logging
if $VIM_FS_VERBOSE == 'true'
  command! -nargs=1 Log echom <args>
else
  command! -nargs=1 Log echom
endif

let s:width = shiftwidth() " FIXME This might not work if shiftwidth is changed
let s:funcRegex = '^\s*\(let\|member\|default\|override\) .\+ =\s*$'
let s:classRegex = '^\s*type .\+ =\s*$'
let s:letClassRegex = s:funcRegex.'\|'.s:classRegex
let s:moduleRegex = '^\s*module .\+ =\s*$'
let s:matchRegex = '\s*match .\+ with$'
let s:matchCaseRegex = '^\s*| .\+ ->.*$'
let s:recordRegex = '^\s*.\+ with$\|{$'

function! s:TrimSpacesAndComments(line)
  let line = substitute(a:line, '\v(.*)\/\/.*', '\1', '')
  return substitute(line, '\v^\s*(.{-})\s*$', '\1', '')
endfunction

function! s:ScopedFind(regex, start_line, scope)
  let lnum = a:start_line
  let max_indent = a:scope
  let indent = a:scope
  let line = ''
  let in_comment = 0
  let blank_lines = 0

  Log 'ScopedFind scope is '.a:scope

  " This loop terminates when a line matches the regex,
  " we reach the top of the file,
  " or we go out of function scope (2 blank lines)
  " In addition, it ignores lines that are indented further
  while lnum >= 0 && blank_lines < 2 && (
        \ in_comment || line == "" || indent > max_indent ||
        \ line !~ a:regex
        \ )
    let lnum -= 1
    let line = getline(lnum)
    let indent = indent(lnum)

    Log 'lnum:'.lnum.', indent:'.indent.', min_indent:'.min_indent.', max_indent:'.max_indent
    Log 'in_comment:'.in_comment.', line:'.line

    " Indicate if we are in a multiline comment
    if line =~ '*)$'
      let in_comment = 1
    endif
    if line =~ '^\s*(*'
      let in_comment = 0
    endif
    if line == ''
      blank_lines += 1
    else
      blank_lines = 0
    endif
  endwhile

  Log 'Blank lines '.blank_lines
  Log 'ScopedFind matched on line '.lnum.': ['.line.']'
  return line =~ a:regex ? lnum : -1
endfunction

function! s:IsInCommentOrString()
  let symbol_type = synIDattr(synID(line("."), col("."), 0), "name")
  Log 'IsInCommentOrString: '.symbol_type.' at line '.line('.').', col '.col('.')
  return (symbol_type =~? 'comment\|string')
endfunction

function! s:SkipFunc()
  return s:IsInCommentOrString()
endfunction

function! s:FindPair(start_word, middle_word, end_word)
  Log 'FindPair: Currently at line: '.line('.').' and column: '.col('.')

  " Make sure we're inside the pair if outside but doesn't affect
  " if we're already inside due to auto-pairs
  execute 'normal! h'
  let lnum = searchpair(a:start_word, a:middle_word, a:end_word,
        \ 'bWn', 's:SkipFunc()')

  Log 'FindPair matched on line '.lnum.': ['.getline(lnum).']'
  return lnum
endfunction

function! s:IndentPair(start_word, middle_word, end_word)
  return indent(s:FindPair(a:start_word, a:middle_word, a:end_word))
endfunction

let s:matchKeyword = '^\s*|$'
let s:matchCase = '^\s*| .*$'
let s:whenKeyword = '^\s*when$'
let s:whenClause = '^\s*when .\+ ->$'
let s:defaultCase = '^\s*| _ -> .\+$'

function! s:IndentMatchExpression(lnum)
  let curr_line = getline(a:lnum)
  let prev_lnum = prevnonblank(a:lnum - 1)
  let prev_line = getline(prev_lnum)
  let prev_indent = indent(prev_lnum)
  let indent = -1

  Log 'Current line: '.curr_line
  Log 'Previous line: '.prev_line

  if curr_line =~ s:matchKeyword.'\|'.s:matchCase.'\|'.s:whenKeyword ||
        \ prev_line =~ s:matchCase.'\|'.s:whenClause.'\|'.s:defaultCase

    let match_lnum = s:ScopedFind(s:matchRegex, a:lnum, prev_indent)

    if match_lnum != -1
      if prev_line =~ s:defaultCase
        Log '!match: default case'
        let indent = indent(match_lnum) - s:width
      elseif curr_line =~ s:matchKeyword.'\|'.s:matchCase
        Log '!match: case'
        let indent = indent(match_lnum)
      else
        Log '!match: result'
        let indent = indent(match_lnum) + s:width
      endif
    endif
  endif

  return indent
endfunction

function! FSharpIndent()
        let current_line = s:TrimSpacesAndComments(getline(v:lnum))
  let current_indent = indent(v:lnum)
  let previous_lnum = prevnonblank(v:lnum - 1)
  let previous_indent = indent(previous_lnum)
  let previous_line = s:TrimSpacesAndComments(getline(previous_lnum))
  let indent = previous_indent

  Log 'Detecting...'

        if v:lnum == 0
    Log '! at line 0. Setting indent to 0'
    return 0
  endif

  let indentForMatch = s:IndentMatchExpression(v:lnum)

  if indentForMatch != -1
    let indent = indentForMatch

  elseif current_line =~ '^}$'
    let indent = s:IndentPair('{', '', '}')
    Log '! dedent `}`: '.indent

  elseif current_line =~ '^\(]\||]\)$'
    let indent = s:IndentPair('\[', '', '\]')
    Log '! dedent `]`: '.indent

  elseif current_line =~ '^)$'
    let indent = s:IndentPair('(', '', ')')
    Log '! dedent `)`: '.indent

  elseif current_line =~ '^|>$'
    Log '! `|>` pipeline operator on current line'
    let indent = previous_indent

  elseif current_line =~ '^\(elif\( .* then\)\?\|else\)$'
    Log '! `elif/else` on current line'
    if previous_line =~ '^\(if\|elif\)'
      let indent = previous_indent
    else
      let indent = previous_indent - s:width
    endif

  elseif current_line =~ '^\s*\w\+ =$'
    Log '! Potential field'
    let lnum = s:ScopedFind(s:recordRegex.'\|'.s:matchRegex, v:lnum, previous_indent)
    let line = lnum == -1 ? '' : getline(lnum)
    if line !~ s:matchRegex && lnum != -1
      let indent = indent(lnum) + s:width
      let indent += line =~ '^\s*{.\+ with$' ? s:width : 0
    endif


  elseif current_line =~ '^\s*\with$'
    Log '! with'
    let indent = previous_indent - s:width

  elseif previous_line =~ '^\s*\(try\|with\)$'
    Log '! try/with'
    let indent = previous_indent + s:width

  elseif previous_line =~ '=\s*$'
    Log '! let/module/member etc ='
    let indent = previous_indent + s:width

  elseif previous_line =~ '^\(let\|type\).*=\(\s\({\|[\|[|\)\)\?$'
    Log '! type/record/array/list'
    let indent = previous_indent + s:width

  elseif previous_line =~ '\([\|[|\|{\|[{\|(\)$'
    Log '! list/record/tuple'
    let indent = previous_indent + s:width

  elseif previous_line =~ '^{ .\+ with$'
    Log '! record copy and update expression (same line)'
    let indent = previous_indent + s:width + s:width

  elseif previous_line =~ '^.\+ with$'
    Log '! record copy and update expression (newline)'
    let indent = previous_indent + s:width

  elseif previous_line =~ '(fun\s.*->$'
    Log '! lambda'
    let indent = previous_indent + s:width

  elseif previous_line =~ '(\s*$'
    Log '! parens'
    let indent = previous_indent + s:width

  elseif previous_line =~ '^|>$'
    Log '! `|>` on previous line'
    let indent = previous_indent + s:width

  elseif (previous_lnum + 3) <= v:lnum
    Log '! two blank lines for end of function'
    if current_line == ''
      let lnum = s:ScopedFind(s:letClassRegex, v:lnum, previous_indent)
      let indent = lnum == -1 ? 0 : indent(lnum)
    else
      let indent = current_indent
    endif

  elseif previous_line =~ '^\s*\(if\|elif\) .* then$'
        \ || previous_line =~ '^else$'
    Log '! if/elif then'
    let indent = previous_indent + s:width

  elseif previous_line =~ '\sdo$'
    Log '! while/for do'
    let indent = previous_indent + s:width

  else
    Log '- keep indent of previous line'
    Log 'line matched ['.line.']'

  endif

  Log 'End of detection. Indent: '.indent

  return indent
endfunction

