CC = go
SHELL = bash
CFLAGS = build -o
OUT_DIR = dist
PROJ_NAME = svix

build: clean deps build-local test
release: build releaser compress
.:  release run

clean:
	$(RM) $(OUT_DIR)/$(PROJ_NAME) && $(RM) $(OUT_DIR)/$(PROJ_NAME).tar.* && $(RM) $(PROJ_NAME).tar.*

deps:
	$(CC) get ./... && $(CC) mod tidy

build-local:
	$(CC) $(CFLAGS) $(OUT_DIR)/$(PROJ_NAME)

run:
	$(OUT_DIR)/$(PROJ_NAME) 

test:
	$(CC) test ./...

compress:
	tar -cf $(OUT_DIR)/$(PROJ_NAME).tar.gz $(OUT_DIR)/$(PROJ_NAME)

releaser:
	$(SHELL) <(curl -sfL https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh) && mv bin/goreleaser . && rm -rf bin
	sudo snap install snapcraft --classic
	./goreleaser  release --snapshot --skip-publish --rm-dist

help: 
	tail -15 Makefile

.PHONY: . deps build test compress run clean all release docs releaser check

#	make
# 		This target is the whole "shebang" (no pun intended) 
#		Run on first install, while developing locally or before releasing
#		Local code changes are preserved, build-artifacts are not
#		If `make` fails, either:
#			1. You broke something
#			2. Breaking changes have been introduced into main
#
#	make build
#		Builds your local source
#
#	make release
#		Builds & compresses a binary release
#		Will exit non-zero if anything fails & safe to use in CI tooling @headername{string}
#