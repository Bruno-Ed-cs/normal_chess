#!/usr/bin/env bash

mkdir -p build
cp -r assets build

odin build . -debug -out:build/normal_chess.bin 

