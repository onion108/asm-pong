.macro ldmem reg lab
adrp \reg, \lab@PAGE
add \reg, \reg, \lab@PAGEOFF
.endm

