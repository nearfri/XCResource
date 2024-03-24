TEMP_DIR=release_temp
EXECUTABLE_NAME = xcresource

ARCHIVE_PATH = $(TEMP_DIR)/$(EXECUTABLE_NAME).xcarchive
ARTIFACTBUNDLE = $(EXECUTABLE_NAME).artifactbundle
ARTIFACTBUNDLE_PATH = $(TEMP_DIR)/$(ARTIFACTBUNDLE)
ARTIFACTBUNDLE_ZIP = $(ARTIFACTBUNDLE).zip
ARTIFACTBUNDLE_ZIP_PATH = $(TEMP_DIR)/$(ARTIFACTBUNDLE_ZIP)
ARCHIVED_EXECUTABLE_PATH = $(ARCHIVE_PATH)/Products/usr/local/bin/$(EXECUTABLE_NAME)
RELEASE_NOTES_PATH = $(TEMP_DIR)/release_notes.md
RELEASE_NOTES_JSON_PATH = $(TEMP_DIR)/release_notes.json

SWIFT_BUILD_FLAGS = -c release
# SWIFT_BUILD_FLAGS = --product $(EXECUTABLE_NAME) -c release --disable-sandbox --arch arm64 --arch x86_64

ROOT_CMD_PATH = Sources/XCResourceCommand/Commands/XCResource.swift

MANIFEST_PATH = ./Package.swift

# Invoke make with GIT_CHECK=false to override this value.
GIT_CHECK = true

VERSION = $(shell sed -En 's/.*version: "(.*)".*/\1/p' $(ROOT_CMD_PATH))
GITHUB_TOKEN = $(shell security find-generic-password -w -s GITHUB_TOKEN)

ARTIFACTBUNDLE_CHECKSUM = $(shell swift package compute-checksum $(ARTIFACTBUNDLE_ZIP_PATH))

RELEASE_RESPONSE_PATH = $(TEMP_DIR)/release_response.json
RELEASE_NOTES_RESPONSE_PATH = $(TEMP_DIR)/release_notes_response.json

RELEASE_ID = $(shell cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['id'])")

RELEASE_NOTES_BODY = $(shell cat $(RELEASE_NOTES_PATH) \
	| sed -E 's/"/\\"/g' | sed -E 's/$$/\\n/g' | tr -d '\n')

ARTIFACTBUNDLE_UPLOAD_URL = $(shell cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['upload_url'])" \
	| sed -E 's/{.*}/?name=$(ARTIFACTBUNDLE_ZIP)/')

define NEWLINE


endef

define ARTIFACTBUNDLE_INFO_TEMPLATE
### Asset Checksums
- $(ARTIFACTBUNDLE_ZIP): `$(ARTIFACTBUNDLE_CHECKSUM)`

### Swift Package Manager snippet
```swift
dependencies: [
	.package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "$(VERSION)"),
],
```
endef
ARTIFACTBUNDLE_INFO = $(subst $(NEWLINE),\n,$(ARTIFACTBUNDLE_INFO_TEMPLATE))

define RELEASE_NOTES_TEMPLATE
{
	"tag_name": "$(VERSION)",
	"target_commitish": "main",
	"body": "$(subst ','\'',$(subst \n,\\n,$(RELEASE_NOTES_BODY)))"
}
endef
RELEASE_NOTES = $(subst $(NEWLINE),\n,$(RELEASE_NOTES_TEMPLATE))

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

.PHONY: default-release
default-release: release

.PHONY: build
build:
	swift build $(SWIFT_BUILD_FLAGS)

.PHONY: release
release: release-local-process release-remote-process _finish_release

.PHONY: release-local-process
release-local-process: _ask-new-version _archive _zip-artifactbundle _update-manifest

.PHONY: print-version
print-version:
	@echo Current Version: $(VERSION)

.PHONY: _ask-new-version
_ask-new-version: _check_git print-version
# .ONESHELL은 make 3.82부터 지원하므로 NEW_VERSION 정의를 위해 eval을 이용한다.
# https://superuser.com/a/1285748
	$(eval NEW_VERSION=$(shell read -p "Enter New Version: " NEW_VER; echo $$NEW_VER))
	
	@if [ -z $(NEW_VERSION) ]; then \
		exit 11; \
	fi

	@sed -E -i '' 's/(version: ")(.*)(",)/\1$(NEW_VERSION)\3/' $(ROOT_CMD_PATH)

.PHONY: _check_git
_check_git:
	@if [ $(GIT_CHECK) == true ]; then \
		if ! git diff-index --quiet HEAD --; then \
			echo "You have uncommitted changes:"; \
			git status -s; \
			echo "If you want to ignore git status, invoke make with \"GIT_CHECK=false\""; \
			exit 10; \
		fi; \
	fi

.PHONY: _archive
_archive:
	mkdir -p $(TEMP_DIR)
# Use xcodebuild due to https://bugs.swift.org/browse/SR-15802
	xcodebuild -scheme $(EXECUTABLE_NAME) -destination generic/platform=macOS \
	-archivePath $(ARCHIVE_PATH) archive

.PHONY: _zip-artifactbundle
_zip-artifactbundle:
	mkdir -p $(ARTIFACTBUNDLE_PATH)/$(EXECUTABLE_NAME)-macos/bin/
	cp $(ARCHIVED_EXECUTABLE_PATH) $(ARTIFACTBUNDLE_PATH)/$(EXECUTABLE_NAME)-macos/bin/
	echo "$$ARTIFACTBUNDLE_MANIFEST" > $(ARTIFACTBUNDLE_PATH)/info.json
	cd $(TEMP_DIR); zip -mr $(ARTIFACTBUNDLE_ZIP) $(ARTIFACTBUNDLE)

.PHONY: _update-manifest
_update-manifest:
	@sed -E -i '' "s/(.*url: .*download\/)(.+)(\/xcresource\.artifact.*)/\1$(VERSION)\3/" $(MANIFEST_PATH); \
	sed -E -i '' "s/(.*checksum: \")([^\"]+)(\".*)/\1$(ARTIFACTBUNDLE_CHECKSUM)\3/" $(MANIFEST_PATH)

.PHONY: release-remote-process
release-remote-process: _git-commit _create-release _upload _update-release-notes _open-release-page

.PHONY: _git-commit
_git-commit:
	git add .
	git commit -m "Update to $(VERSION)"
	git tag $(VERSION)
	git push origin $(VERSION)

.PHONY: _create-release
_create-release:
	@echo Create a release $(VERSION)
	
	@if [ -z $(GITHUB_TOKEN) ]; then \
		echo "GITHUB_TOKEN not found in the keychain."; \
		exit 20; \
	fi

	curl -X POST \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-H "Content-Type:application/json" \
		-d '{"tag_name":"$(VERSION)","target_commitish":"main","prerelease":true,"generate_release_notes":true}' \
		-o "$(RELEASE_RESPONSE_PATH)" \
		https://api.github.com/repos/nearfri/XCResource/releases

.PHONY: _upload
_upload:
	@if [ ! -f $(RELEASE_RESPONSE_PATH) ]; then \
		echo "$(RELEASE_RESPONSE_PATH) file not found."; \
		exit 30; \
	fi

	curl -X POST \
		-T "$(ARTIFACTBUNDLE_ZIP_PATH)" \
		-H "Content-Type: $(shell file -b --mime-type $(ARTIFACTBUNDLE_ZIP_PATH))" \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		"$(ARTIFACTBUNDLE_UPLOAD_URL)" \
	| cat

.PHONY: _update-release-notes
_update-release-notes: _generate-release-notes-file
	@echo Update a release notes

	@echo '$(RELEASE_NOTES)' > $(RELEASE_NOTES_JSON_PATH)

	curl -X PATCH \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-H "Content-Type: application/json" \
		--data-binary @$(RELEASE_NOTES_JSON_PATH) \
		-o "$(RELEASE_NOTES_RESPONSE_PATH)" \
		https://api.github.com/repos/nearfri/XCResource/releases/$(RELEASE_ID)

.PHONY: _generate-release-notes-file
_generate-release-notes-file:
# Write auto-generated release notes first
	@cat $(RELEASE_RESPONSE_PATH) \
	| python3 -c "import sys, json; print(json.load(sys.stdin)['body'])" \
	| tr -d '\r' \
	> $(RELEASE_NOTES_PATH)

	@echo '\n$(ARTIFACTBUNDLE_INFO)' >> $(RELEASE_NOTES_PATH)

.PHONY: _open-release-page
_open-release-page:
	open https://github.com/nearfri/XCResource/releases

.PHONY: _finish_release
_finish_release:
	rm -rf $(TEMP_DIR)
	@echo "The $(VERSION) update has been completed."
	@echo "Please finish with 'git push origin main'."
