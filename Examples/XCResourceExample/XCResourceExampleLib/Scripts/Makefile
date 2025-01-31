XCRESOURCE = xcrun --sdk macosx swift run --package-path ../../../../ xcresource

PROJECT_NAME = XCResourceExample
PROJECT_DIR = ../Sources/Resources
RESOURCES_DIR = $(PROJECT_DIR)/Resources
RESOURCEKEYS_DIR = $(PROJECT_DIR)/ResourceAccess

IMAGEKEY_FILE = $(RESOURCEKEYS_DIR)/$(IMAGEKEY_NAME).swift
COLORKEY_FILE = $(RESOURCEKEYS_DIR)/$(COLORKEY_NAME).swift
FILEKEY_FILE = $(RESOURCEKEYS_DIR)/$(FILEKEY_NAME).swift
FONTKEY_FILE = $(RESOURCEKEYS_DIR)/$(FONTKEY_NAME).swift
STRINGKEY_FILE = $(RESOURCEKEYS_DIR)/LocalizedStringResource+.swift

IMAGEKEY_NAME = ImageKey
COLORKEY_NAME = ColorKey
FILEKEY_NAME = FileResource
FONTKEY_NAME = FontResource

ASSETS_DIR = $(RESOURCES_DIR)/Assets.xcassets
ASSET_CONTENTS_FILES := $(shell find $(ASSETS_DIR) -name "Contents.json" | sed 's/ /\\ /g')

# It's fast. But it doesn't run when adding images with Zeplin.
#ASSET_CONTENTS_FILES := $(shell find $(ASSETS_DIR) -type d -print0 \
#	| xargs -0 dirname | sort | uniq | sed '1d; s/ /\\ /g; s/$$/\/Contents.json/')

#asset_contents_files = $(shell find -E $(ASSETS_DIR) -type d -regex $(1) -print0 \
#	| xargs -0 dirname | sort | uniq | sed 's/ /\\ /g; s/$$/\/Contents.json/')
#IMAGE_CONTENTS_FILES = $(call asset_contents_files,'.+\.imageset$$')

.SUFFIXES:

.PHONY: default
default: xcassets2swift files2swift fonts2swift xcstrings2swift

.PHONY: xcassets2swift
xcassets2swift: images2swift colors2swift

.PHONY: images2swift
images2swift: $(IMAGEKEY_FILE)

$(IMAGEKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type imageset \
	--swift-file-path $@ \
	--resource-type-name $(IMAGEKEY_NAME) \
	--bundle Bundle.module \
	--access-level public
	
	@touch $@

.PHONY: colors2swift
colors2swift: $(COLORKEY_FILE)

$(COLORKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type colorset \
	--swift-file-path $@ \
	--resource-type-name $(COLORKEY_NAME) \
	--bundle Bundle.module \
	--access-level public
	
	@touch $@

.PHONY: files2swift
files2swift:
	$(XCRESOURCE) files2swift \
	--resources-path $(RESOURCES_DIR)/Fonts \
	--file-pattern "(?i)\\.(otf|ttf|ttc)$$" \
	--swift-file-path $(FILEKEY_FILE) \
	--resource-type-name $(FILEKEY_NAME) \
	--preserve-relative-path \
	--relative-path-prefix Fonts \
	--bundle Bundle.module \
	--access-level public
	
.PHONY: fonts2swift
fonts2swift:
	$(XCRESOURCE) fonts2swift \
	--resources-path $(RESOURCES_DIR) \
	--swift-file-path $(FONTKEY_FILE) \
	--resource-type-name $(FONTKEY_NAME) \
	--resource-list-name all \
	--transform-to-latin \
	--strip-combining-marks \
	--preserve-relative-path \
	--bundle Bundle.module \
	--access-level public
	
.PHONY: xcstrings2swift
xcstrings2swift:
	$(XCRESOURCE) xcstrings2swift \
	--catalog-path $(RESOURCES_DIR)/Localizable.xcstrings \
	--bundle atURL:Bundle.module.bundleURL \
	--swift-file-path $(STRINGKEY_FILE)
