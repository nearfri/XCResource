XCRESOURCE_DEBUG = xcrun --sdk macosx swift run --package-path ../../../ xcresource
XCRESOURCE_RELEASE = xcresource
XCRESOURCE_MINT = xcrun --sdk macosx mint run xcresource

XCRESOURCE = $(XCRESOURCE_RELEASE)

PROJECT_NAME = XCResourceApp
PROJECT_DIR = ../$(PROJECT_NAME)
RESOURCES_DIR = $(PROJECT_DIR)
RESOURCEKEYS_DIR = $(PROJECT_DIR)/ResourceKeys

IMAGEKEY_FILE = $(RESOURCEKEYS_DIR)/$(IMAGEKEY_NAME).swift
COLORKEY_FILE = $(RESOURCEKEYS_DIR)/$(COLORKEY_NAME).swift
STRINGKEY_FILE = $(RESOURCEKEYS_DIR)/$(STRINGKEY_NAME).swift
STRINGFORM_FILE = $(RESOURCEKEYS_DIR)/$(STRINGFORM_NAME).swift

IMAGEKEY_NAME = ImageKey
COLORKEY_NAME = ColorKey
STRINGKEY_NAME = StringKey
STRINGFORM_NAME = StringForm

ASSETS_DIR = $(RESOURCES_DIR)/Assets.xcassets
ASSET_CONTENTS_FILES := $(shell find $(ASSETS_DIR) -name "Contents.json" | sed 's/ /\\ /g')

# It's fast. But it doesn't run when adding images with Zeplin.
#ASSET_CONTENTS_FILES := $(shell find $(ASSETS_DIR) -type d -print0 \
#	| xargs -0 dirname | sort | uniq | sed '1d; s/ /\\ /g; s/$$/\/Contents.json/')

#asset_contents_files = $(shell find -E $(ASSETS_DIR) -type d -regex $(1) -print0 \
#	| xargs -0 dirname | sort | uniq | sed 's/ /\\ /g; s/$$/\/Contents.json/')
#IMAGE_CONTENTS_FILES = $(call asset_contents_files,'.+\.imageset$$')

SWIFT2STRINGS_STRATEGIES = ko:comment *:dont-add
SWIFT2STRINGS_LASTRUN_FILE = ./swift2strings-lastrun

LOCALIZABLE_STRINGS_FILES = $(wildcard $(RESOURCES_DIR)/*.lproj/Localizable.strings)

LOCALIZATION_CSV_FILE = ./$(PROJECT_NAME)-localizations.csv
LOCALIZATION_DEV_LANGUAGE = ko
LOCALIZATION_CSV_STYLE = long-ko

.SUFFIXES:

.PHONY: default
default: xcassets2swift key2form swift2strings

.PHONY: xcassets2swift
xcassets2swift: images2swift colors2swift

.PHONY: images2swift
images2swift: $(IMAGEKEY_FILE)

$(IMAGEKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type imageset \
	--swift-path $@ \
	--swift-type-name $(IMAGEKEY_NAME)
	
	@touch $@

.PHONY: colors2swift
colors2swift: $(COLORKEY_FILE)

$(COLORKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type colorset \
	--swift-path $@ \
	--swift-type-name $(COLORKEY_NAME)
	
	@touch $@

.PHONY: key2form
key2form: $(STRINGFORM_FILE)

$(STRINGFORM_FILE): $(STRINGKEY_FILE)
	$(XCRESOURCE) key2form \
	--key-file-path $< \
	--form-file-path $@ \
	--form-type-name $(STRINGFORM_NAME) \
	--issue-reporter xcode
	
	@touch $@

.PHONY: swift2strings
swift2strings: $(SWIFT2STRINGS_LASTRUN_FILE)

$(SWIFT2STRINGS_LASTRUN_FILE): $(STRINGKEY_FILE)
	$(XCRESOURCE) swift2strings \
	--swift-path $< \
	--resources-path $(RESOURCES_DIR) \
	--merge-strategy $(SWIFT2STRINGS_STRATEGIES) \
	--enable-comment-comparison
	
	@touch $@

# Non-default targets

.PHONY: strings2csv
strings2csv: $(LOCALIZATION_CSV_FILE)

$(LOCALIZATION_CSV_FILE): $(LOCALIZABLE_STRINGS_FILES)
	$(XCRESOURCE) strings2csv \
	--resources-path $(RESOURCES_DIR) \
	--development-language $(LOCALIZATION_DEV_LANGUAGE) \
	--csv-path $(LOCALIZATION_CSV_FILE) \
	--header-style $(LOCALIZATION_CSV_STYLE) \
	--empty-encoding "#EMPTY" \
	--write-bom

.PHONY: csv2strings
csv2strings:
#	Remove "\r" characters
	@if grep -q '\r' $(LOCALIZATION_CSV_FILE); then \
		echo "sed -i '' 's/\\\r//g' $(LOCALIZATION_CSV_FILE)"; \
		sed -i '' 's/\r//g' $(LOCALIZATION_CSV_FILE); \
	fi
	
	$(XCRESOURCE) csv2strings \
	--csv-path $(LOCALIZATION_CSV_FILE) \
	--header-style $(LOCALIZATION_CSV_STYLE) \
	--resources-path $(RESOURCES_DIR) \
	--empty-encoding "#EMPTY"
