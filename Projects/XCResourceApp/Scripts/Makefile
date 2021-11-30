XCRESOURCE_DEV = xcrun --sdk macosx swift run --package-path ../../../ xcresource
XCRESOURCE_MINT = xcrun --sdk macosx mint run xcresource

XCRESOURCE = $(XCRESOURCE_MINT)

PROJECT_DIR = ../XCResourceApp
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
ASSET_FILES = $(shell find $(ASSETS_DIR) -name 'Contents.json' | sed 's/ /\\ /g')

SWIFT2STRINGS_LANGUAGES = ko
SWIFT2STRINGS_STRATEGIES = ko:comment
SWIFT2STRINGS_LASTRUN_FILE = ./swift2strings-lastrun

LOCALIZABLE_STRINGS_FILES = $(wildcard $(RESOURCES_DIR)/*.lproj/Localizable.strings)

TRANSLATION_CSV_FILE = ./SampleApp-translation.csv
TRANSLATION_DEV_LANGUAGE = ko
TRANSLATION_CSV_STYLE = long-ko

.SUFFIXES:

.PHONY: default
default: xcassets2swift swift2strings key2form strings2csv

.PHONY: xcassets2swift
xcassets2swift: images2swift colors2swift

.PHONY: images2swift
images2swift: $(IMAGEKEY_FILE)

$(IMAGEKEY_FILE): $(ASSET_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type imageset \
	--swift-path $@ \
	--swift-type-name $(IMAGEKEY_NAME)
	
	@touch $@

.PHONY: colors2swift
colors2swift: $(COLORKEY_FILE)

$(COLORKEY_FILE): $(ASSET_FILES)
	$(XCRESOURCE) xcassets2swift \
	--xcassets-path $(ASSETS_DIR) \
	--asset-type colorset \
	--swift-path $@ \
	--swift-type-name $(COLORKEY_NAME)
	
	@touch $@

.PHONY: swift2strings
swift2strings: $(SWIFT2STRINGS_LASTRUN_FILE)

$(SWIFT2STRINGS_LASTRUN_FILE): $(STRINGKEY_FILE)
	$(XCRESOURCE) swift2strings \
	--swift-path $< \
	--resources-path $(RESOURCES_DIR) \
	--language $(SWIFT2STRINGS_LANGUAGES) \
	--value-strategy $(SWIFT2STRINGS_STRATEGIES)
	
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

.PHONY: strings2csv
strings2csv: $(TRANSLATION_CSV_FILE)

$(TRANSLATION_CSV_FILE): $(LOCALIZABLE_STRINGS_FILES)
	$(XCRESOURCE) strings2csv \
	--resources-path $(RESOURCES_DIR) \
	--development-language $(TRANSLATION_DEV_LANGUAGE) \
	--csv-path $(TRANSLATION_CSV_FILE) \
	--header-style $(TRANSLATION_CSV_STYLE) \
	--write-bom

# Non-default targets

.PHONY: csv2strings
csv2strings:
#	Remove "\r" characters
	@if grep -q '\r' $(TRANSLATION_CSV_FILE); then \
		echo "sed -i '' 's/\\\r//g' $(TRANSLATION_CSV_FILE)"; \
		sed -i '' 's/\r//g' $(TRANSLATION_CSV_FILE); \
	fi
	
	$(XCRESOURCE) csv2strings \
	--csv-path $(TRANSLATION_CSV_FILE) \
	--header-style $(TRANSLATION_CSV_STYLE) \
	--resources-path $(RESOURCES_DIR)
