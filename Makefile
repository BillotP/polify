


all: ## Build android release apk, upload it to keep.sh and get a qrcode to download from your device, same with linux app
	@flutter build apk
	@curl --upload-file ./build/app/outputs/flutter-apk/app-release.apk https://free.keep.sh > link.out
	@qrencode -o android-apk.png $(shell cat link.out)
	# @code android-apk.png && rm android-apk.png link.out

clean:
	@flutter clean
	@dart run build_runner build --delete-conflicting-outputs
	@rm android-apk.png linux-exe.png link.out || true