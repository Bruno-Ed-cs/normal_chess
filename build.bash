#!/usr/bin/env bash

mkdir -p build
cp -r assets build

odin build ./src -debug -out:build/normal_chess.bin 

