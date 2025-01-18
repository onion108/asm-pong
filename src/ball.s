.include "inc/constants.inc"
.include "inc/window.inc"

// struct Ball {
//     i32 x;
//     i32 y;
//     i32 r;
//     i32 vx;
//     i32 vy;
// }


// render_ball(struct Ball *ball);
.global render_ball
render_ball:
eor x1, x1, x1
ldr w1, [x0]   // x
eor x2, x2, x2
ldr w2, [x0, #4] // y
eor x3, x3, x3
ldr w3, [x0, #8] // r

// void DrawCircle(int centerX, int centerY, float radius, Color color);
mov x0, x1 // x
mov x1, x2 // y
scvtf s0, x3 // r
eor x2, x2, x2
mov w5, #0xFF
bfi w2, w5, #0, #8
bfi w2, w5, #8, #8
bfi w2, w5, #16, #8
bfi w2, w5, #24, #8

str lr, [sp, #-16]!
bl _DrawCircle
ldr lr, [sp], #16

ret
// end render_ball

// update_ball(struct Ball *ball, struct Pad *pad_left, struct Pad *pad_right, struct Score *score);
.global update_ball
update_ball:

// Move the ball
ldp w9, w10, [x0, #12] // w9=vx, w10=vy
ldp w11, w12, [x0]
add w11, w11, w9 // x += vx
add w12, w12, w10 // y += vy
stp w11, w12, [x0]

ldr w13, [x0, #8] // w13 = r

// {{{ Screen checks

// Check lower bound and perform collide
mov w14, WIN_HEIGHT
sub w14, w14, w13
cmp w12, w14
bgt update_ball__lower_collide
b update_ball__lower_collide_end

update_ball__lower_collide:
// Set Y speed
mov w10, -BALL_SPEED
str w10, [x0, #16]
update_ball__lower_collide_end:


// Check upper bound and perform collide
cmp w12, w13
blt update_ball__upper_collide
b update_ball__upper_collide_end

update_ball__upper_collide:
mov w10, BALL_SPEED
str w10, [x0, #16]
update_ball__upper_collide_end:

// Check right bound and perform score update
sub w11, w11, w13
cmp w11, WIN_WIDTH
add w11, w11, w13
bgt update_ball__right_collide
b update_ball__right_collide_end
update_ball__right_collide:
ldr w4, [x3]
add w4, w4, #1
str w4, [x3]

str lr, [sp, #-16]!
bl reset_ball
ldr lr, [sp], #16
ret
update_ball__right_collide_end:

// Check left bound and perform score update
neg w13, w13
cmp w11, w13
neg w13, w13
blt update_ball__left_collide
b update_ball__left_collide_end
update_ball__left_collide:
ldr w4, [x3, #4]
add w4, w4, #1
str w4, [x3, #4]

str lr, [sp, #-16]!
bl reset_ball
ldr lr, [sp], #16
ret
update_ball__left_collide_end:

// }}}

// Check ball out of pads
ldr w14, [x2] // Right pad's x coord
ldr w15, [x2, #8] // Right pad's width
add w14, w14, w15
cmp w11, w14 // Compare with X coord
bgt update_ball__pad_collide_end

ldr w14, [x1] // Left pad's X coord
cmp w11, w14
blt update_ball__pad_collide_end

// {{{ Pad Collide checks 
update_ball__pad_collide:

// Check right pad and perform collide
ldr w14, [x2] // Load pad x to w14
sub w14, w14, w11 // w14 = right_pad.x - ball.x
cmp w14, w13
blt update_ball__right_pad_collide_check2
b update_ball__right_pad_collide_checks_end

update_ball__right_pad_collide_check2:
// Check if y coordinate of the ball bigger than pad's y value
ldr w14, [x2, #4]
cmp w12, w14
bge update_ball__right_pad_collide_check3
b update_ball__right_pad_collide_checks_end

update_ball__right_pad_collide_check3:
// Check if y coordinate of the ball smaller than pad's y value plus pad's height
ldr w15, [x2, #12]
add w14, w14, w15
cmp w12, w14
ble update_ball__right_pad_collide
// b update_ball__right_pad_collide_checks_end

update_ball__right_pad_collide_checks_end:
b update_ball__right_pad_collide_end

update_ball__right_pad_collide:
// Set X speed
mov w9, -BALL_SPEED
str w9, [x0, #12]
update_ball__right_pad_collide_end:

// Check left pad and perform collide
ldr w14, [x1] // Load pad x to w14
sub w14, w11, w14 // w14 = ball.x - left_pad.x
cmp w14, w13
blt update_ball__left_pad_collide_check2
b update_ball__left_pad_collide_checks_end

update_ball__left_pad_collide_check2:
// Check if y coordinate of the ball smaller than pad's y value
ldr w14, [x1, #4]
ldr w15, [x1, #8]
sub w14, w14, w15
cmp w12, w14
bge update_ball__left_pad_collide_check3
b update_ball__left_pad_collide_checks_end

update_ball__left_pad_collide_check3:
// Check if y coordinate of the ball smaller than pad's y value plus pad's height
ldr w15, [x1, #12]
add w14, w14, w15
cmp w12, w14
ble update_ball__left_pad_collide
// b update_ball__left_pad_collide_checks_end

update_ball__left_pad_collide_checks_end:
b update_ball__left_pad_collide_end

update_ball__left_pad_collide:
// Set X speed
mov w9, BALL_SPEED
str w9, [x0, #12]
update_ball__left_pad_collide_end:
update_ball__pad_collide_end:
// }}}

ret

// reset_ball(struct Ball *ball);
.global reset_ball
reset_ball:
mov w1, #400
mov w2, #300
mov w3, BALL_SPEED
mov w4, BALL_SPEED
stp w1, w2, [x0]
stp w3, w4, [x0, #12]
ret
// end reset_ball

