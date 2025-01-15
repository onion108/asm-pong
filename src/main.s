.global _start
.align 2
.include "inc/util.inc"
.include "inc/window.inc"
.include "inc/keycode.inc"
.include "inc/constants.inc"

.text
_start:
mov x0, #1
ldmem x1, msg
mov x2, msg_len
mov x16, #4
svc #0

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

bl _EndDrawing
b frame_process

close_window:
// CloseWindow(void)
bl _CloseWindow

exit:
mov x0, #0
mov x16, #1
svc #0

.data
msg: .asciz "Pong in Assembly (WIP) \n"
msg_len =  . - msg - 1

// Pads to control
pad_left:
.word 30 // x
.word 260 // y
.word 5  // w
.word 80 // h

pad_right:
.word 765 // x
.word 260 // y
.word 5 // w
.word 80 // h

ball:
.word 400         // x
.word 300         // y (#4)
.word 5           // r (#8)
.word BALL_SPEED  // vx (#12)
.word BALL_SPEED  // vy (#16)

