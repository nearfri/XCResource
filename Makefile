EXECUTABLE_NAME = xcresource
EXECUTABLE_DIR = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path | sed "s|^$$PWD/||")
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE_NAME)

ARCHIVE_PATH = $(EXECUTABLE_NAME).xcarchive
ARCHIVE_ZIP_PATH = $(EXECUTABLE_NAME).zip
ARCHIVED_EXECUTABLE_PATH = $(ARCHIVE_PATH)/Products/usr/local/bin/$(EXECUTABLE_NAME)

INSTALL_DIR = /usr/local/bin
INSTALL_PATH = $(INSTALL_DIR)/$(EXECUTABLE_NAME)

SWIFT_BUILD_FLAGS = -c release
# SWIFT_BUILD_FLAGS = --product $(EXECUTABLE_NAME) -c release --disable-sandbox --arch arm64 --arch x86_64

ROOT_CMD_PATH = Sources/XCResourceCommand/Commands/XCResource.swift
MINTFILE_PATH = Samples/XCResourceApp/Scripts/Mintfile

# Invoke make with GIT_CHECK=false to override this value.
GIT_CHECK ?= true

LATEST_TAG = $(shell git describe --tags --abbrev=0)
GITHUB_TOKEN = $(shell security find-generic-password -w -s GITHUB_TOKEN)
RESPONSE_PATH = tmp_response.json
UPLOAD_URL = $(shell cat $(RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['upload_url'])" \
	| sed -E 's/{.*}/?name=$(EXECUTABLE_NAME).zip/')
HTML_URL = $(shell cat $(RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['html_url'])")

.PHONY: all
all: build

.PHONY: build
build:
	swift build $(SWIFT_BUILD_FLAGS)

.PHONY: archive
archive:
# Use xcodebuild due to https://bugs.swift.org/browse/SR-15802
	xcodebuild -scheme $(EXECUTABLE_NAME) -destination generic/platform=macOS \
	-archivePath $(ARCHIVE_PATH) archive

.PHONY: zip
zip:
	zip -jr $(ARCHIVE_ZIP_PATH) $(ARCHIVED_EXECUTABLE_PATH)

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

.PHONY: reset
reset:
	swift package reset

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
	
# .ONESHELL은 make 3.82부터 지원하므로 NEW_VERSION 정의를 위해 eval을 이용한다.
# https://superuser.com/a/1285748
# Bug: eval이 위의 git 체크보다 먼저 실행되는 문제가 있다.
	$(eval NEW_VERSION=$(shell read -p "Enter New Version: " NEW_VER; echo $$NEW_VER))
	
	@if [ -z $(NEW_VERSION) ]; then \
		exit 11; \
	fi
	
	@sed -E -i '' 's/(version: ")(.*)(",)/\1$(NEW_VERSION)\3/' $(ROOT_CMD_PATH)
	@sed -E -i '' 's/(@)(.*)/\1$(NEW_VERSION)/' $(MINTFILE_PATH)
	
	git add .
	git commit -m "Update to $(NEW_VERSION)"
	git tag $(NEW_VERSION)
	git push origin $(NEW_VERSION)

.PHONY: version
version:
	@echo Current Version: $$(sed -En 's/.*version: "(.*)".*/\1/p' $(ROOT_CMD_PATH))

.PHONY: release
release:
	@echo Create a release $(LATEST_TAG)
	
	@if [ -z $(GITHUB_TOKEN) ]; then \
		echo "GITHUB_TOKEN not found in the keychain."; \
		exit 20; \
	fi

	curl -X POST \
    	-H "Authorization: token $(GITHUB_TOKEN)" \
    	-H "Accept: application/vnd.github.v3+json" \
    	-H "Content-Type:application/json" \
    	-d '{"tag_name":"$(LATEST_TAG)","target_commitish":"main","draft":true,"generate_release_notes":true}' \
		-o "$(RESPONSE_PATH)" \
    	https://api.github.com/repos/nearfri/XCResource/releases
	
.PHONY: upload
upload:
	@if [ ! -f $(RESPONSE_PATH) ]; then \
		echo "$(RESPONSE_PATH) file not found."; \
		exit 30; \
	fi

	curl -X POST \
		-T "$(ARCHIVE_ZIP_PATH)" \
		-H "Content-Type: $(shell file -b --mime-type $(ARCHIVE_ZIP_PATH))" \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		"$(UPLOAD_URL)" \
	| cat

	open $(HTML_URL)
