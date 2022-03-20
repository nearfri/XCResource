EXECUTABLE_NAME = xcresource
EXECUTABLE_DIR = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path | sed "s|^$$PWD/||")
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE_NAME)

INSTALL_DIR = /usr/local/bin
INSTALL_PATH = $(INSTALL_DIR)/$(EXECUTABLE_NAME)

SWIFT_BUILD_FLAGS = -c release
# SWIFT_BUILD_FLAGS = --product $(EXECUTABLE_NAME) -c release --disable-sandbox --arch arm64 --arch x86_64

ROOT_CMD_PATH = Sources/XCResourceCommand/Commands/XCResource.swift
MINTFILE_PATH = Samples/XCResourceApp/Scripts/Mintfile

# Invoke make with GIT_CHECK=false to override this value.
GIT_CHECK ?= true

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
	install $(EXECUTABLE_PATH) $(INSTALL_PATH)

.PHONY: uninstall
uninstall:
	rm -f $(INSTALL_PATH)

.PHONY: clean
clean:
	swift package clean

.PHONY: clean-all
clean-all:
	rm -rf .build

.PHONY: new-version
new-version: version
	@if [ $(GIT_CHECK) == true ]; then \
		if ! git diff-index --quiet HEAD --; then \
			echo "You have uncommitted changes."; \
			git status -s; \
			echo "If you want to ignore git status, invoke make with \"GIT_CHECK=false\""; \
			exit 10; \
		fi; \
	fi
	
#	.ONESHELL은 make 3.82부터 지원하므로 NEW_VERSION 정의를 위해 eval을 이용한다.
#	https://superuser.com/a/1285748
#	Bug: eval이 위의 git 체크보다 먼저 실행되는 문제가 있다.
	$(eval NEW_VERSION=$(shell read -p "Enter New Version: " NEW_VER; echo $$NEW_VER))
	
	@if [ -z $(NEW_VERSION) ]; then \
		exit 11; \
	fi
	
	@sed -E -i '' 's/(version: ")(.*)(",)/\1$(NEW_VERSION)\3/' $(ROOT_CMD_PATH)
	@sed -E -i '' 's/(@)(.*)/\1$(NEW_VERSION)/' $(MINTFILE_PATH)
	
	git add .
	git commit -m "Update to $(NEW_VERSION)"
	git tag $(NEW_VERSION)

.PHONY: version
version:
	@echo Current Version: $$(sed -En 's/.*version: "(.*)".*/\1/p' $(ROOT_CMD_PATH))
