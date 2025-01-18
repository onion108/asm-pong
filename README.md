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

## Working Progress
- [x] Implement pad movement.
- [x] Implement ball movement.
- [x] Implement ball collision.
- [x] Implement scores.
- [x] Implement score display.

