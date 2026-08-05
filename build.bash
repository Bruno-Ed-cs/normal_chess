#!/usr/bin/env bash
shopt -s expand_aliases
source ~/.bashrc

mkdir -p build
cp -r assets build

odin build ./src -debug -out:build/normal_chess.bin 

