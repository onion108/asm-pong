.include "inc/util.inc"
.include "inc/constants.inc"
.include "inc/window.inc"

// struct Score {
//     u32 left;
//     u32 right;
// }

.text
// render_score(struct Score *)
.global render_score
render_score:
// Clear x1 and x2, for them to be able to use as 64-bit value without fear.
eor x1, x1, x1
eor x2, x2, x2

ldr w1, [x0]
ldr w2, [x0, #4]
// w1 = left, w2 = = right

// Draw the left text
str lr, [sp, #-16]!
mov x0, x1
bl score_itoa // This function doesn't use register x1 through x4, 
              // and x0 is now useless because all values needed are 
              // loaded, hence it's safe not to save x1 and x2.
ldr lr, [sp], #16

// Ready for calling DrawText
str x1, [sp, #-16]!
str x2, [sp, #-16]!
str lr, [sp, #-16]!

ldmem x0, score_text_buf // Text
mov x1, 0                // X-coord
mov x2, 0                // Y-coord
mov x3, SCORE_TEXT_SIZE  // Font Size

mov w5, #0xFF            // Color
bfi w4, w5, #0, #8
bfi w4, w5, #8, #8
bfi w4, w5, #16, #8
bfi w4, w5, #24, #8

bl _DrawText
ldr lr, [sp], #16
ldr x2, [sp], #16
ldr x1, [sp], #16
// End call DrawText, x1 and x2 remains content

// Draw the right text
str lr, [sp, #-16]!
mov x0, x2
bl score_itoa
ldr lr, [sp], #16

// From here x1 and x2 are all useless and can be used.

// Get width of the text.
ldmem x0, score_text_buf
mov x1, SCORE_TEXT_SIZE
str lr, [sp, #-16]!
bl _MeasureText
ldr lr, [sp], #16

mov x1, WIN_WIDTH
sub x1, x1, x0    // x1 = WIN_WIDTH - text_width

// Ready to call DrawText!
ldmem x0, score_text_buf // Text
                         // X-Coord calculated and stored in the correct reg, skip
mov x2, 0                // Y-Coord
mov x3, SCORE_TEXT_SIZE  // Font Size
mov w5, #0xFF            // Color
bfi w4, w5, #0, #8
bfi w4, w5, #8, #8
bfi w4, w5, #16, #8
bfi w4, w5, #24, #8
// Here we go.
str lr, [sp, #-16]!
bl _DrawText
ldr lr, [sp], #16

ret

// {{{ score_itoa(u32 number)
score_itoa:
ldmem x5, score_text_buf
cmp w0, #0
beq score_itoa__write_zero
b score_itoa__write_zero_end

score_itoa__write_zero:
mov w6, #0x30  // Write character '0'
strb w6, [x5]
mov w6, #0   // Write end zero byte
strb w6, [x5, #1]
ret
score_itoa__write_zero_end:

mov x6, sp
score_itoa__digit_loop:
mov x7, 10
udiv x8, x0, x7     // x8 = number / 10
msub x8, x8, x7, x0 // x8 = x8 * 10 - number (aka x8 = number % 10)
udiv x0, x0, x7     // x8 /= 10
str x8, [sp, #-16]! // push x8 to the stack

cmp w0, #0
beq score_itoa__digit_loop_end
b score_itoa__digit_loop
score_itoa__digit_loop_end:

score_itoa__output_loop:
ldr x7, [sp], #16  // Pop a digit out
add x7, x7, #0x30  // add the digit with 0x30 (ASCII of character '0')
strb w7, [x5], #1 // Add character to the buffer

cmp sp, x6 // Check if there is no longer more digit
beq score_itoa__output_loop_end
b score_itoa__output_loop
score_itoa__output_loop_end:

// Write the trailing zero
mov w7, #0
strb w7, [x5, #1]

ret
// }}}

.data
score_text_buf: 
.rept 12
.byte 0
.endr

