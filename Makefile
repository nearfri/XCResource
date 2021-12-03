EXECUTABLE_NAME = xcresource
EXECUTABLE_DIR = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE_NAME)

INSTALL_DIR = /usr/local/bin
INSTALL_PATH = $(INSTALL_DIR)/$(EXECUTABLE_NAME)

SWIFT_BUILD_FLAGS = -c release
# SWIFT_BUILD_FLAGS = --product $(EXECUTABLE_NAME) -c release --disable-sandbox --arch arm64 --arch x86_64

.PHONY: all
all: build

.PHONY: build
build:
	swift build $(SWIFT_BUILD_FLAGS)

.PHONY: test
test:
	swift test

.PHONY: install
install:
	install "$(EXECUTABLE_PATH)" $(INSTALL_PATH)

.PHONY: uninstall
uninstall:
	rm -f $(INSTALL_PATH)

.PHONY: clean
clean:
	swift package clean

.PHONY: clean-all
clean-all:
	rm -rf .build
