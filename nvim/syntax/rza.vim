if exists("b:current_syntax")
  finish
endif

syn keyword rzaKeyword
    \ cav res med raise decay probe load loadb
    \ mov store storeb slt inc dec await print
    \ jmp brz brnz call proc casc acasc endc ret layout
    \ add sub mul div mod and or xor shl shr
syn keyword rzaType u8 i64
syn match rzaType "\v<[A-Z][A-Za-z0-9_]*>"
syn keyword rzaConstant field
syn match rzaRegister "\v[%%]r([0-9]|1[0-5])>"
syn match rzaField "\]\.\zs[a-z_][a-z0-9_]*"
syn match rzaLabel "\(proc\s\+\)\@<=[a-z_][a-z0-9_]*"
syn match rzaLabel "^\s*\zs[a-z_][a-z0-9_]*\ze:"
syn match rzaNumber "\v(^|[^A-Za-z0-9_])\zs-?\d+>"
syn match rzaNumber "\v(^|[^A-Za-z0-9_])\zs-?0x[0-9A-Fa-f]+>"
syn region rzaComment start=";" end="$"

hi def link rzaKeyword Keyword
hi def link rzaType Type
hi def link rzaConstant Constant
hi def link rzaRegister Identifier
hi def link rzaField Special
hi def link rzaLabel Function
hi def link rzaNumber Number
hi def link rzaComment Comment

let b:current_syntax = "rza"
