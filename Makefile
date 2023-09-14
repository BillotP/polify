
BUILD ?= $(shell git rev-parse --short HEAD)
VERSION ?= $(shell cat pubspec.yaml | grep 'version:' | cut -d " " -f 2 | cut -d "+" -f 1)

default:
	@make all

updatebuild:
	@sed -i 's/\(version:.*\).../version: $(VERSION)+$(BUILD)/' pubspec.yaml

android:
	@make updatebuild
	@PATH="$$PATH":"$$HOME/.pub-cache/bin" flutter_distributor package --platform android --targets=apk,aab
	@export F="polify-$(VERSION)+$(BUILD)-android.apk" &&  curl -s --upload-file "./dist/$(VERSION)+$(BUILD)/$$F" "https://transfer.sh/$$F" -o link.out
	@echo "[INFO] Updating download link qrcode" && qrencode -o android-apk.png -r link.out

deb:
	@echo "Building dot DEB package for polify v$(VERSION)+$(BUILD)"
	@flutter_distributor package --platform linux --targets deb

all:
	@make updatebuild
	@make android
	@make deb

clean:
	@flutter clean
	@rm -rf dist link.out android-apk.png || true
	@dart run build_runner build --delete-conflicting-outputs


.PHONY: android all clean deb