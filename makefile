
all: release debug

release: build
	odin build ./src/main.odin -file -out:build/normal_chess.bin 

debug: build
	odin build -debug -build-mode:dynamic -define:RAYLIB_SHARED=true -out:build/engine.so src/engine
	odin build -debug -out:build/normal_chess_dev.bin -file src/runner.odin

build:
	mkdir -p build
	cp -r assets build

clean:
	rm -rf build/
