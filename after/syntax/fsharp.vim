" Vim syntax file
" Language: F#

syntax clear

" reset 'iskeyword' setting
setl iskeyword&vim

" sync from start to avoid paren match errors
syn sync fromstart

" fsharp is case sensitive.
syn case match

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

" Strings
syn match  fsharpFormat display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bscdiuxXoEefFgGMOAat]\|\[\^\=.[^]]*\]\)" contained
syn region fsharpInterpolation matchgroup=fsharpOperator start="{" end="}" containedin=fsharpInterpolatedString

syn match  fsharpCharacter "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match  fsharpCharacter "'\\\d\d'\|'\\\d'"
syn match  fsharpCharacter "'\\[^\'ntbr]'"

syn region fsharpString             start=+"+    skip=+\\\\\|\\"+ end=+"+   contains=fsharpFormat
syn region fsharpString             start=+@"+   skip=+""+        end=+"+   contains=fsharpFormat
syn region fsharpInterpolatedString start=+$"+                    end=+"+   contains=fsharpFormat,fsharpInterpolation
syn region fsharpString             start=+"""+  skip=+\\\\\|\\"+ end=+"""+ contains=fsharpFormat
syn region fsharpInterpolatedString start=+$"""+                  end=+"""+ contains=fsharpFormat,fsharpInterpolation
syn region fsharpVariable           start="``"                    end="``"  keepend oneline

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

" Keywords
syn keyword fsharpConstant    null
syn keyword fsharpInclude     open
syn keyword fsharpKeyword     abstract and as asr assert base begin break checked class component const const constraint
syn keyword fsharpKeyword     continue default delegate do done downcast downto elif else end event exception extern
syn keyword fsharpKeyword     external finally fixed for fun function global if in include inherit inline interface
syn keyword fsharpKeyword     internal land lazy let lor lsl lsr lxor match member mixin mod module mutable namespace
syn keyword fsharpKeyword     new not of or override parallel private process protected public pure rec return sealed
syn keyword fsharpKeyword     select sig static struct tailcall then to trait try type upcast use val virtual void when
syn keyword fsharpKeyword     while with yield
syn keyword fsharpStatement   all averageBy averageByNullable count distinct exactlyOne exactlyOneOrDefault
syn keyword fsharpStatement   exists find groupBy groupJoin groupValBy head headOrDefault into join last lastOrDefault
syn keyword fsharpStatement   leftOuterJoin maxBy maxByNullable minBy minByNullable nth on select skip skipWhile sortBy
syn keyword fsharpStatement   sortByDescending sortByNullable sortByNullableDescending sumBy sumByNullable take takeWhile
syn keyword fsharpStatement   thenBy thenByDescending thenByNullable thenByNullableDescending where

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

" Builtin functions
syn keyword fsharpFunction abs acos array2D asin async atan atan2 box byte ceil char compare cos cosh decr defaultArg
syn keyword fsharpFunction defaultValueArg dict double enum eprintf eprintfn exit exp failwith failwithf floor fprintf
syn keyword fsharpFunction fprintfn fst get hash id ignore incr infinity infinityf int8 invalidArg invalidOp isNull
syn keyword fsharpFunction limitedHash lock log log10 max methodhandleof min nameof nan nanf not nullArg pown printf
syn keyword fsharpFunction printfn query raise readOnlyDict ref reraise round rows sbyte seq set sign sin single sinh
syn keyword fsharpFunction sizeof snd sprintf sqrt stderr stdin stdout tan tanh truncate tryUnbox typedefof typeof
syn keyword fsharpFunction uint8 unbox using

" Scripting/preprocessor directives
syn match   fsharpSScript "^\s*#\S\+" transparent contains=fsharpScript

syn match   fsharpScript contained "#"
syn keyword fsharpScript contained quitlabels warnings directory cd load use
syn keyword fsharpScript contained install_printer remove_printer requirethread
syn keyword fsharpScript contained trace untrace untrace_all print_depth
syn keyword fsharpScript contained print_length define undef if elif else endif
syn keyword fsharpScript contained line error warning light nowarn

" Highlight links
hi def link fsharpAttribBraces       PreProc
hi def link fsharpAttribute          PreProc
hi def link fsharpBoolean            Boolean
hi def link fsharpCharacter          Character
hi def link fsharpComment            Comment
hi def link fsharpConstant           Constant
hi def link fsharpDelimiter          Delimiter
hi def link fsharpError              Error
hi def link fsharpFloat              Float
hi def link fsharpFormat             Operator
hi def link fsharpFunction           Function
hi def link fsharpInclude            Include
hi def link fsharpInterpolatedString fsharpString
hi def link fsharpKeyword            Keyword
hi def link fsharpNumber             Number
hi def link fsharpOperator           Operator
hi def link fsharpScript             Include
hi def link fsharpStatement          Statement
hi def link fsharpString             String
hi def link fsharpTodo               Todo
hi def link fsharpType               Type
hi def link fsharpTypedef            Typedef

let b:current_syntax = 'fsharp'

" vim: sw=4 et sts=4
