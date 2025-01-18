.global _start
.align 2
.include "inc/util.inc"
.include "inc/window.inc"
.include "inc/keycode.inc"
.include "inc/constants.inc"

.text
_start:

// InitWindow(int, int, const char*)
mov x0, WIN_WIDTH 
mov x1, WIN_HEIGHT
adrp x2, msg@PAGE
add x2, x2, msg@PAGEOFF
bl _InitWindow

mov x0, 60
bl _SetTargetFPS

frame_process:
bl _WindowShouldClose
cbnz x0, close_window

ldmem x0, pad_left
mov x1, KEY_W
mov x2, KEY_S
bl control_pad

ldmem x0, pad_right
mov x1, KEY_UP
mov x2, KEY_DOWN
bl control_pad

ldmem x0, ball
ldmem x1, pad_left
ldmem x2, pad_right
ldmem x3, score
bl update_ball

bl _BeginDrawing

// ClearBackground(0x181818FF)
mov w1, #0x18
bfi w0, w1, #0, #8 // Red value
bfi w0, w1, #8, #8 // Green value
bfi w0, w1, #16, #8 // Blue value
mov w1, #0xFF
bfi w0, w1, #24, #8 // Alpha value
bl _ClearBackground

ldmem x0, pad_left
bl render_pad

ldmem x0, pad_right
bl render_pad

ldmem x0, ball
bl render_ball

ldmem x0, score
bl render_score

bl _EndDrawing

mov x0, KEY_R
bl _IsKeyPressed
cbnz w0, call_reset
b end_call_reset
call_reset:
bl reset_everything
end_call_reset:

b frame_process

close_window:
// CloseWindow(void)
bl _CloseWindow

exit:
mov x0, #0
mov x16, #1
svc #0

reset_everything:
ldmem x2, pad_left
mov x0, 30
mov x1, (WIN_HEIGHT-80)/2
stp w0, w1, [x2]
mov x0, 5
mov x1, 80
stp w0, w1, [x2, #8]

ldmem x2, pad_right 
mov x0, WIN_WIDTH-30-5
mov x1, (WIN_HEIGHT-80)/2
stp w0, w1, [x2]
mov x0, 5
mov x1, 80
stp w0, w1, [x2, #8]

ldmem x2, score
mov x0, 0
stp w0, w0, [x2]

str lr, [sp, #-16]!
ldmem x0, ball
bl reset_ball
ldr lr, [sp], #16

ret

.data
msg: .asciz "Pong in Assembly (WIP) \n"
msg_len =  . - msg - 1

// Pads to control
pad_left:
.word 30                // x
.word (WIN_HEIGHT-80)/2 // y (#4)
.word 5                 // w (#8)
.word 80                // h (#16)

pad_right:
.word WIN_WIDTH-30-5    // x
.word (WIN_HEIGHT-80)/2 // y (#4)
.word 5                 // w (#8)
.word 80                // h (#16)

ball:
.word 400               // x
.word 300               // y (#4)
.word 10                // r (#8)
.word BALL_SPEED        // vx (#12)
.word BALL_SPEED        // vy (#16)

score:
.word 0 // left
.word 0 // right (#4)

