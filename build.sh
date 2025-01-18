#!/bin/zsh

mkdir -p dist
mkdir -p obj

as -o obj/main.o src/main.s || exit 1
as -o obj/pad.o src/pad.s || exit 1
as -o obj/ball.o src/ball.s || exit 1
as -o obj/score.o src/score.s || exit 1

ld obj/main.o obj/pad.o obj/ball.o obj/score.o `pkg-config --libs raylib` -macos_version_min 15.0.0 -o dist/main -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

