
BUILD ?= $(shell git rev-parse --short HEAD)
VERSION ?= $(shell cat pubspec.yaml | grep 'version:' | cut -d " " -f 2 | cut -d "+" -f 1)

updatebuild:
	@sed -i 's/\(version:.*\).../version: $(VERSION)+$(BUILD)/' pubspec.yaml

android:
	@flutter_distributor package --platform android --targets=apk,aab
	@curl --upload-file ./build/app/outputs/flutter-apk/app-release.apk https://free.keep.sh > link.out
	@qrencode -o android-apk.png $(shell cat link.out)

deb:
	@echo "Building dot DEB package for polify v$(VERSION)+$(BUILD)"
	@flutter_distributor package --platform linux --targets deb

all: ## Build android release apk, upload it to keep.sh and get a qrcode to download from your device, same with linux app
	make updatebuild
	make android
	make deb

clean:
	@flutter clean
	@dart run build_runner build --delete-conflicting-outputs

.PHONY: android all clean deb