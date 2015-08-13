.PHONY: build run clean

hs-source-dirs = app
main-is        = Main.hs

build:
	stack build

run: build
	stack runghc $(hs-source-dirs)/$(main-is)

