.include "inc/window.inc"
.include "inc/constants.inc"
// struct Pad {
//     i32 x;
//     i32 y;
//     i32 w;
//     i32 h;
// }


// render_pad(struct Pad *pad)
.global render_pad
render_pad:
eor x1, x1, x1
eor x2, x2, x2
eor x3, x3, x3
eor x4, x4, x4
ldr w1, [x0]
ldr w2, [x0, #4]
ldr w3, [x0, #8]
ldr w4, [x0, #12]

mov x0, x1
mov x1, x2
mov x2, x3
mov x3, x4
mov w5, #0xFF
bfi w4, w5, #0, #8
bfi w4, w5, #8, #8
bfi w4, w5, #16, #8
bfi w4, w5, #24, #8

str lr, [sp, #-16]!
bl _DrawRectangle
ldr lr, [sp], #16
ret

// end render_pad

// control_pad(struct Pad *pad, int keyup, int keydown)
.global control_pad
control_pad:

// Calle reserved regs we may use
str x19, [sp, #-16]!
str x20, [sp, #-16]!
str x21, [sp, #-16]!
mov x19, x0
mov x20, x1
mov x21, x2


str x19, [sp, #-16]!
str x20, [sp, #-16]!
str x21, [sp, #-16]!
str lr, [sp, #-16]!

mov x0, x21
bl _IsKeyDown

ldr lr, [sp], #16
ldr x21, [sp], #16
ldr x20, [sp], #16
ldr x19, [sp], #16
cbnz x0, control_pad__move_down

str x19, [sp, #-16]!
str x20, [sp, #-16]!
str x21, [sp, #-16]!
str lr, [sp, #-16]!

mov x0, x20
bl _IsKeyDown

ldr lr, [sp], #16
ldr x21, [sp], #16
ldr x20, [sp], #16
ldr x19, [sp], #16
cbnz x0, control_pad__move_up

b end_control_pad

control_pad__move_down:
eor x0, x0, x0
eor x1, x1, x1
ldr w0, [x19, #4] // Y value of the pad
ldr w1, [x19, #12] // Height of the pad
add x2, x0, x1
cmp x2, WIN_HEIGHT-10
bgt control_pad__move_down_end

add x0, x0, PAD_SPEED
str w0, [x19, #4]

control_pad__move_down_end:
b end_control_pad
control_pad__move_up:
eor x0, x0, x0
eor x1, x1, x1
ldr w0, [x19, #4] // Y value of the pad
ldr w1, [x19, #12] // Height of the pad
cmp x0, #10
blt control_pad__move_up_end

sub x0, x0, PAD_SPEED
str w0, [x19, #4]

control_pad__move_up_end:
b end_control_pad

end_control_pad:
ldr x21, [sp], #16
ldr x20, [sp], #16
ldr x19, [sp], #16
ret
// end control_pad

