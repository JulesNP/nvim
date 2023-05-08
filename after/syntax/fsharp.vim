" Vim syntax file
" Language: F#

syntax clear

" reset 'iskeyword' setting
setl isk&vim

" sync from start to avoid paren match errors
syn sync fromstart

" fsharp is case sensitive.
syn case match

" Scripting/preprocessor directives
syn match   fsharpSScript "^\s*#\S\+" transparent contains=fsharpScript

syn match   fsharpScript contained "#"
syn keyword fsharpScript contained quitlabels warnings directory cd load use
syn keyword fsharpScript contained install_printer remove_printer requirethread
syn keyword fsharpScript contained trace untrace untrace_all print_depth
syn keyword fsharpScript contained print_length define undef if elif else endif
syn keyword fsharpScript contained line error warning light nowarn

" Operators
syn match   fsharpDelimiter ","
syn match   fsharpDelimiter ";"
syn match   fsharpOperator  "!"
syn match   fsharpOperator  "&"
syn match   fsharpOperator  "*"
syn match   fsharpOperator  "+"
syn match   fsharpOperator  "-"
syn match   fsharpOperator  "/"
syn match   fsharpOperator  ":"
syn match   fsharpOperator  "<"
syn match   fsharpOperator  "="
syn match   fsharpOperator  ">"
syn match   fsharpOperator  "?"
syn match   fsharpOperator  "\."
syn match   fsharpOperator  "\<_\>"
syn match   fsharpOperator  "\~"
syn match   fsharpOperator  "|"
syn keyword fsharpOperator  not and or

" Errors
syn keyword fsharpError failwith failwithf invalid_arg raise
syn keyword fsharpError rethrow

syn match fsharpError "}"
syn match fsharpError "]"
syn match fsharpError ")"
syn match fsharpError "|)"
syn match fsharpError "|]"
syn match fsharpError "|}"
syn match fsharpError ">]"
syn match fsharpError "\*)"

" Enclosing delimiters
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="("   end=")"  contains=ALLBUT,fsharpError
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="{"   end="}"  contains=ALLBUT,fsharpError
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="\["  end="]"  contains=ALLBUT,fsharpError
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="(|"  end="|)" contains=ALLBUT,fsharpError
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="\[|" end="|]" contains=ALLBUT,fsharpError
syn region fsharpMatchParen transparent matchgroup=fsharpOperator start="{|"  end="|}" contains=ALLBUT,fsharpError

" Comments
syn match   fsharpComment "//.*$"               contains=@Spell,fsharpTodo
syn region  fsharpComment start="///" end="$"   contains=@Spell,fsharpTodo keepend oneline
syn region  fsharpComment start="(\*" end="\*)" contains=@Spell,fsharpTodo
syn keyword fsharpTodo contained TODO FIXME XXX NOTE

" Strings
syn match  fsharpFormat display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bscdiuxXoEefFgGMOAat]\|\[\^\=.[^]]*\]\)" contained
syn region fsharpInterpolation matchgroup=fsharpOperator start="{" end="}" contained

syn match  fsharpCharacter "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match  fsharpCharacter "'\\\d\d'\|'\\\d'"
syn match  fsharpCharacter "'\\[^\'ntbr]'"

syn region fsharpString             start=+"+    skip=+\\\\\|\\"+ end=+"+   contains=fsharpFormat
syn region fsharpString             start=+@"+   skip=+""+        end=+"+   contains=fsharpFormat
syn region fsharpInterpolatedString start=+$"+                    end=+"+   contains=fsharpFormat,fsharpInterpolation
syn region fsharpString             start=+"""+  skip=+\\\\\|\\"+ end=+"""+ contains=fsharpFormat
syn region fsharpInterpolatedString start=+$"""+                  end=+"""+ contains=fsharpFormat,fsharpInterpolation
syn region fsharpString             start="``"                    end="``"  keepend oneline

" Keywords
syn keyword fsharpConditional if elif try finally else match with then
syn keyword fsharpConstant    null
syn keyword fsharpRepeat      for while
syn keyword fsharpInclude     open module namespace
syn keyword fsharpKeyword     abstract as assert base begin class default delegate do done downcast downto end exception extern
syn keyword fsharpKeyword     fun function global in inherit inline interface lazy let member mutable new of override
syn keyword fsharpKeyword     rec static struct to type upcast use val void when
syn keyword fsharpStatement   orderBy select where yield

" Value literals
syn keyword fsharpBoolean true false
syn match   fsharpNumber  "\<\d\+"
syn match   fsharpNumber  "\<-\=\d\(_\|\d\)*\(u\|u\?[yslLn]\|UL\)\?\>"
syn match   fsharpNumber  "\<-\=0[x|X]\(\x\|_\)\+\(u\|u\?[yslLn]\|UL\)\?\>"
syn match   fsharpNumber  "\<-\=0[o|O]\(\o\|_\)\+\(u\|u\?[yslLn]\|UL\)\?\>"
syn match   fsharpNumber  "\<-\=0[b|B]\([01]\|_\)\+\(u\|u\?[yslLn]\|UL\)\?\>"
syn match   fsharpFloat   "\<-\=\d\(_\|\d\)*\.\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"
syn match   fsharpFloat   "\<-\=\d\(_\|\d\)*\.\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"
syn match   fsharpFloat   "\<\d\+\.\d*"

" Types
syn keyword fsharpType array bool byte char decimal double enum exn float float32 int int16 int32 int64 lazy_t list nativeint
syn keyword fsharpType obj option sbyte single string uint uint32 uint64 uint16 unativeint unit
syn match   fsharpType "\v'[A-Za-z0-9_]+(')@!"
syn region  fsharpAttribute matchgroup=fsharpAttribBraces start="\[<" end=">]" contains=ALLBUT,fsharpError

" Highlight links
hi def link fsharpAttribBraces       PreProc
hi def link fsharpAttribute          PreProc
hi def link fsharpBoolean            Boolean
hi def link fsharpCharacter          Character
hi def link fsharpComment            Comment
hi def link fsharpConditional        Conditional
hi def link fsharpConstant           Constant
hi def link fsharpDelimiter          Delimiter
hi def link fsharpError              Error
hi def link fsharpFloat              Float
hi def link fsharpFormat             Operator
hi def link fsharpInclude            Include
hi def link fsharpInterpolatedString fsharpString
hi def link fsharpKeyword            Keyword
hi def link fsharpNumber             Number
hi def link fsharpOperator           Operator
hi def link fsharpRepeat             Repeat
hi def link fsharpScript             Include
hi def link fsharpStatement          Statement
hi def link fsharpString             String
hi def link fsharpTodo               Todo
hi def link fsharpType               Type
hi def link fsharpTypedef            Typedef

let b:current_syntax = 'fsharp'

" vim: sw=4 et sts=4
