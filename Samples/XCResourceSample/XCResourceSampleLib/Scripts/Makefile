XCRESOURCE_DEBUG = xcrun --sdk macosx swift run --package-path ../../../../ xcresource
XCRESOURCE_RELEASE = xcresource
XCRESOURCE_MINT = xcrun --sdk macosx mint run xcresource

XCRESOURCE = $(XCRESOURCE_DEBUG)

PROJECT_NAME = XCResourceSample
PROJECT_DIR = ../Sources/Resources
RESOURCES_DIR = $(PROJECT_DIR)/Resources
RESOURCEKEYS_DIR = $(PROJECT_DIR)/Keys

IMAGEKEY_FILE = $(RESOURCEKEYS_DIR)/$(IMAGEKEY_NAME).swift
COLORKEY_FILE = $(RESOURCEKEYS_DIR)/$(COLORKEY_NAME).swift
FONTKEY_FILE = $(RESOURCEKEYS_DIR)/$(FONTKEY_NAME).swift
STRINGKEY_FILE = $(RESOURCEKEYS_DIR)/$(STRINGKEY_NAME).swift
STRINGFORM_FILE = $(RESOURCEKEYS_DIR)/$(STRINGFORM_NAME).swift

IMAGEKEY_NAME = ImageKey
COLORKEY_NAME = ColorKey
FONTKEY_NAME = FontKey
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

FONTS_DIR = $(RESOURCES_DIR)/Fonts
FONTS_DIR_FILES := $(shell find $(FONTS_DIR) | sed 's/ /\\ /g')

SWIFT2STRINGS_LANGUAGE_CONFIG = en:comment:verify-comments all:dont-add
SWIFT2STRINGSDICT_LANGUAGE_CONFIG = en:comment all:dont-add
SWIFT2STRINGS_LASTRUN_FILE = ./swift2strings-lastrun

LOCALIZABLE_STRINGS_FILES = $(wildcard $(RESOURCES_DIR)/*.lproj/Localizable.strings)

LOCALIZATION_CSV_FILE = ./$(PROJECT_NAME)-localizations.csv
LOCALIZATION_DEV_LANGUAGE = en
LOCALIZATION_CSV_STYLE = long-en
LOCALIZATION_CSV_EMPTY_ENCODING = "\#EMPTY"

.SUFFIXES:

.PHONY: default
default: xcassets2swift fonts2swift

.PHONY: xcassets2swift
xcassets2swift: images2swift colors2swift

.PHONY: images2swift
images2swift: $(IMAGEKEY_FILE)

$(IMAGEKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type imageset \
	--swift-path $@ \
	--key-type-name $(IMAGEKEY_NAME) \
	--access-level public
	
	@touch $@

.PHONY: colors2swift
colors2swift: $(COLORKEY_FILE)

$(COLORKEY_FILE): $(ASSET_CONTENTS_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type colorset \
	--swift-path $@ \
	--key-type-name $(COLORKEY_NAME) \
	--access-level public
	
	@touch $@

.PHONY: fonts2swift
fonts2swift: $(FONTKEY_FILE)

$(FONTKEY_FILE): $(FONTS_DIR_FILES)
	$(XCRESOURCE) fonts2swift \
	--fonts-path $(FONTS_DIR) \
	--swift-path $@ \
	--key-type-name $(FONTKEY_NAME) \
	--access-level public
	
	@touch $@

# Non-default targets

.PHONY: key2form
key2form: $(STRINGFORM_FILE)

$(STRINGFORM_FILE): $(STRINGKEY_FILE)
	$(XCRESOURCE) key2form \
	--key-file-path $< \
	--form-file-path $@ \
	--form-type-name $(STRINGFORM_NAME) \
	--access-level public \
	--issue-reporter xcode
	
	@touch $@

.PHONY: swift2strings
swift2strings: $(SWIFT2STRINGS_LASTRUN_FILE)

$(SWIFT2STRINGS_LASTRUN_FILE): $(STRINGKEY_FILE)
	$(XCRESOURCE) swift2strings \
	--swift-path $< \
	--resources-path $(RESOURCES_DIR) \
	--language-config $(SWIFT2STRINGS_LANGUAGE_CONFIG)
	
	$(XCRESOURCE) swift2stringsdict \
	--swift-path $< \
	--resources-path $(RESOURCES_DIR) \
	--language-config $(SWIFT2STRINGSDICT_LANGUAGE_CONFIG)
	
	@touch $@

.PHONY: strings2swift
strings2swift:
	$(XCRESOURCE) strings2swift \
	--resources-path $(RESOURCES_DIR) \
	--language $(LOCALIZATION_DEV_LANGUAGE) \
	--swift-path $(STRINGKEY_FILE)

.PHONY: stringsdict2swift
stringsdict2swift:
	$(XCRESOURCE) stringsdict2swift \
	--resources-path $(RESOURCES_DIR) \
	--language $(LOCALIZATION_DEV_LANGUAGE) \
	--swift-path $(STRINGKEY_FILE)

.PHONY: strings2csv
strings2csv: $(LOCALIZATION_CSV_FILE)

$(LOCALIZATION_CSV_FILE): $(LOCALIZABLE_STRINGS_FILES)
	$(XCRESOURCE) strings2csv \
	--resources-path $(RESOURCES_DIR) \
	--development-language $(LOCALIZATION_DEV_LANGUAGE) \
	--csv-path $(LOCALIZATION_CSV_FILE) \
	--header-style $(LOCALIZATION_CSV_STYLE) \
	--empty-encoding $(LOCALIZATION_CSV_EMPTY_ENCODING) \
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
	--empty-encoding $(LOCALIZATION_CSV_EMPTY_ENCODING)
