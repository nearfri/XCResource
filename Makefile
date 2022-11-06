EXECUTABLE_NAME = xcresource
EXECUTABLE_DIR = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path | sed "s|^$$PWD/||")
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE_NAME)

ARCHIVE_PATH = $(EXECUTABLE_NAME).xcarchive
ARTIFACTBUNDLE_PATH = $(EXECUTABLE_NAME).artifactbundle
EXECUTABLE_ZIP = $(EXECUTABLE_NAME).zip
ARTIFACTBUNDLE_ZIP = $(ARTIFACTBUNDLE_PATH).zip
ARCHIVED_EXECUTABLE_PATH = $(ARCHIVE_PATH)/Products/usr/local/bin/$(EXECUTABLE_NAME)
RELEASE_NOTES_FILE = release_notes.md
RELEASE_NOTES_JSON_FILE = release_notes.json

INSTALL_DIR = /usr/local/bin
INSTALL_PATH = $(INSTALL_DIR)/$(EXECUTABLE_NAME)

SWIFT_BUILD_FLAGS = -c release
# SWIFT_BUILD_FLAGS = --product $(EXECUTABLE_NAME) -c release --disable-sandbox --arch arm64 --arch x86_64

ROOT_CMD_PATH = Sources/XCResourceCommand/Commands/XCResource.swift
MINTFILE_PATH = Samples/XCResourceSample/XCResourceSampleLib/Scripts/Mintfile

# Invoke make with GIT_CHECK=false to override this value.
GIT_CHECK ?= true

VERSION = $(shell sed -En 's/.*version: "(.*)".*/\1/p' $(ROOT_CMD_PATH))
RELEASE_TAG = $(shell git describe --tags --abbrev=0)
GITHUB_TOKEN = $(shell security find-generic-password -w -s GITHUB_TOKEN)

EXECUTABLE_CHECKSUM = $(shell swift package compute-checksum $(EXECUTABLE_ZIP))
ARTIFACTBUNDLE_CHECKSUM = $(shell swift package compute-checksum $(ARTIFACTBUNDLE_ZIP))

RELEASE_RESPONSE_PATH = release_response.json
RELEASE_NOTES_RESPONSE_PATH = release_notes_response.json

RELEASE_ID = $(shell cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['id'])")

RELEASE_NOTES_BODY = $(shell cat $(RELEASE_NOTES_FILE) \
	| sed -e 's/"/\\"/g' | sed -e 's/$$/\\n/g' | tr -d '\n')

EXECUTABLE_UPLOAD_URL = $(shell cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['upload_url'])" \
	| sed -E 's/{.*}/?name=$(EXECUTABLE_ZIP)/')

ARTIFACTBUNDLE_UPLOAD_URL = $(shell cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['upload_url'])" \
	| sed -E 's/{.*}/?name=$(ARTIFACTBUNDLE_ZIP)/')

define ARTIFACTBUNDLE_INFO
### Asset Checksums
- $(EXECUTABLE_ZIP) `$(EXECUTABLE_CHECKSUM)`
- $(ARTIFACTBUNDLE_ZIP) `$(ARTIFACTBUNDLE_CHECKSUM)`

### Swift Package Manager snippet
```swift
.binaryTarget(
    name: "$(EXECUTABLE_NAME)",
    url: "https://github.com/nearfri/XCResource/releases/download/$(RELEASE_TAG)/$(ARTIFACTBUNDLE_ZIP)",
    checksum: "$(ARTIFACTBUNDLE_CHECKSUM)"
)
```
endef
export ARTIFACTBUNDLE_INFO

define RELEASE_NOTES
{
	"tag_name": "$(RELEASE_TAG)",
	"target_commitish": "main",
	"body": "$(subst \n,\\n,$(RELEASE_NOTES_BODY))"
}
endef
export RELEASE_NOTES

define ARTIFACTBUNDLE_MANIFEST
{
    "schemaVersion": "1.0",
    "artifacts": {
        "$(EXECUTABLE_NAME)": {
            "type": "executable",
            "version": "$(VERSION)",
            "variants": [
                {
                    "path": "$(EXECUTABLE_NAME)-macos/bin/$(EXECUTABLE_NAME)",
                    "supportedTriples": ["x86_64-apple-macosx", "arm64-apple-macosx"]
                }
            ]
        }
    }
}
endef
export ARTIFACTBUNDLE_MANIFEST

####################################################################################################

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
zip: zip-executable zip-artifactbundle

.PHONY: zip-executable
zip-executable:
	zip -jr $(EXECUTABLE_ZIP) $(ARCHIVED_EXECUTABLE_PATH)

.PHONY: zip-artifactbundle
zip-artifactbundle:
	mkdir -p $(ARTIFACTBUNDLE_PATH)/$(EXECUTABLE_NAME)-macos/bin/
	cp $(ARCHIVED_EXECUTABLE_PATH) $(ARTIFACTBUNDLE_PATH)/$(EXECUTABLE_NAME)-macos/bin/
	echo "$$ARTIFACTBUNDLE_MANIFEST" > $(ARTIFACTBUNDLE_PATH)/info.json
	zip -mr $(ARTIFACTBUNDLE_ZIP) $(ARTIFACTBUNDLE_PATH)

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

	$(MAKE) set-version NEW_VERSION=$(NEW_VERSION)

	git add .
	git commit -m "Update to $(NEW_VERSION)"
	git tag $(NEW_VERSION)
	git push origin $(NEW_VERSION)

.PHONY: set-version
set-version:
	@if [ -z $(NEW_VERSION) ]; then \
		echo "Invoke make with \"NEW_VERSION=x.y.z\""; \
		exit 11; \
	fi
	
	@sed -E -i '' 's/(version: ")(.*)(",)/\1$(NEW_VERSION)\3/' $(ROOT_CMD_PATH)
	@sed -E -i '' 's/(@)(.*)/\1$(NEW_VERSION)/' $(MINTFILE_PATH)

.PHONY: version
version:
	@echo Current Version: $(VERSION)

.PHONY: distribute
distribute: archive zip create-release upload update-release-notes open-release-page

.PHONY: create-release
create-release:
	@echo Create a release $(RELEASE_TAG)
	
	@if [ -z $(GITHUB_TOKEN) ]; then \
		echo "GITHUB_TOKEN not found in the keychain."; \
		exit 20; \
	fi

	curl -X POST \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-H "Content-Type:application/json" \
		-d '{"tag_name":"$(RELEASE_TAG)","target_commitish":"main","draft":true,"generate_release_notes":true}' \
		-o "$(RELEASE_RESPONSE_PATH)" \
		https://api.github.com/repos/nearfri/XCResource/releases

.PHONY: update-release-notes
update-release-notes:
	@echo Update a release notes

# Write auto-generated release notes first
	@cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['body'])" \
	| tr -d '\r' \
	> $(RELEASE_NOTES_FILE)

	@echo "\n$$ARTIFACTBUNDLE_INFO" >> $(RELEASE_NOTES_FILE)

	@echo "$$RELEASE_NOTES" > $(RELEASE_NOTES_JSON_FILE)
	
	curl -X PATCH \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-H "Content-Type:application/json" \
		--data-binary @$(RELEASE_NOTES_JSON_FILE) \
		-o "$(RELEASE_NOTES_RESPONSE_PATH)" \
		https://api.github.com/repos/nearfri/XCResource/releases/$(RELEASE_ID)
	
.PHONY: upload
upload:
	@if [ ! -f $(RELEASE_RESPONSE_PATH) ]; then \
		echo "$(RELEASE_RESPONSE_PATH) file not found."; \
		exit 30; \
	fi

	curl -X POST \
		-T "$(EXECUTABLE_ZIP)" \
		-H "Content-Type: $(shell file -b --mime-type $(EXECUTABLE_ZIP))" \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		"$(EXECUTABLE_UPLOAD_URL)" \
	| cat

	curl -X POST \
		-T "$(ARTIFACTBUNDLE_ZIP)" \
		-H "Content-Type: $(shell file -b --mime-type $(ARTIFACTBUNDLE_ZIP))" \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		"$(ARTIFACTBUNDLE_UPLOAD_URL)" \
	| cat

.PHONY: open-release-page
open-release-page:
	open https://github.com/nearfri/XCResource/releases
