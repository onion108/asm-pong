# ASM Pong

A classic "Pong" game implemented in AArch64 assembly, for macOS.

Theoretically it should be able to compile on any other aarch64 linux system since it uses raylib to render and doesn't use macOS-specific things, but I'm too lazy to write a build script for 'em.

Just for fun.

## Dependency
`raylib`

## Build
```sh
./build.sh
```
Executable will be placed at `dist/`.

## Build Configurations
You can adjust some constants in `inc/constants.inc` and `inc/window.inc` to change things like score display's font size, window size etc.
Here are some features that can be enabled or disabled in `inc/config.inc`, they are documented here.

### `FEATURE_RKEY_RESET`
When enabled, you can press R to reset the game state.

### `FEATURE_RANDOM`
When enabled, the ball's direction will be randomly generated per reset (include resetting ball because of scoring).
It's off by default because it seems to bring a weird game experience, though I tried to make it feel more natural.

## Working Progress
- [x] Implement pad movement.
- [x] Implement ball movement.
- [x] Implement ball collision.
- [x] Implement scores.
- [x] Implement score display.

