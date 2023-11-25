
BUILD_COMMIT ?= $(shell git rev-parse --short HEAD)
BUILD_DATE ?= $(shell date +%Y%m%d)
BUILD	= $(BUILD_DATE)
APP_NAME := $(shell head -n 1 README.md | cut -d ' ' -f2 |  tr '[:upper:]' '[:lower:]')
VERSION ?= $(shell cat pubspec.yaml | grep 'version:' | cut -d " " -f 2 | cut -d "+" -f 1)

help: ## Print this help message and exit
	@echo -e "\n\t\t$(APP_NAME) \033[1mmake\033[0m options:\n"
	@perl -nle 'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "- \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo -e "\n"

default: help

updatebuild: ## Replace build part in pubspec.yaml version tag
	@sed -i 's/\(version:.*\).../version: $(VERSION)+$(BUILD)/' pubspec.yaml

android: ## Build android apk and aab application releases
	@make updatebuild
	@flutter_distributor package --platform android --targets=apk,aab
	@export F="polify-$(VERSION)+$(BUILD)-android.apk" && \
	 export D="./dist/$(VERSION)+$(BUILD)/$$F" && \
	 echo "[INFO] Uploading $$F to transfer.sh" && \
	 curl --progress-bar --upload-file "$$D" "https://transfer.sh/$$F" -o link.out
	@echo "[INFO] Updating download link qrcode" && qrencode -t UTF8 -r link.out

deb: ## Package desktop app for linux debian like distros
	@echo "Building dot DEB package for polify v$(VERSION)+$(BUILD)"
	@flutter_distributor package --platform linux --targets deb

all: ## Release for linux desktop and android devices
	@make updatebuild
	@make android
	@make deb

clean: ## Remove artefacts
	@flutter clean
	@rm -rf dist link.out android-apk.png || true
	@dart run build_runner build --delete-conflicting-outputs


.PHONY: android all clean deb