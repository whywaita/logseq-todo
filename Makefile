.PHONY: build clean test release

APP_NAME = LogseqTodo
BUNDLE_ID = com.whywaita.logseq-todo
VERSION = $(shell cat version.txt)

build:
	swift build -c release --arch arm64

app: build
	mkdir -p build/$(APP_NAME).app/Contents/MacOS
	mkdir -p build/$(APP_NAME).app/Contents/Resources
	cp .build/arm64-apple-macosx/release/$(APP_NAME) build/$(APP_NAME).app/Contents/MacOS/
	chmod +x build/$(APP_NAME).app/Contents/MacOS/$(APP_NAME)
	sed -e 's|<string>1.0</string>|<string>$(VERSION)</string>|' \
	    -e 's|<string>1</string>|<string>$(VERSION)</string>|' \
	    Sources/LogseqTodo/Info.plist > build/$(APP_NAME).app/Contents/Info.plist
	cp version.txt build/$(APP_NAME).app/Contents/Resources/
	xcrun actool Assets.xcassets --compile build/$(APP_NAME).app/Contents/Resources --platform macosx --minimum-deployment-target 15.0 --app-icon AppIcon --output-partial-info-plist /tmp/partial-info.plist
	echo "APPL????" > build/$(APP_NAME).app/Contents/PkgInfo
	codesign --force --deep --sign - build/$(APP_NAME).app

dmg: app
	create-dmg \
		--volname "$(APP_NAME)" \
		--window-pos 200 120 \
		--window-size 600 300 \
		--icon-size 100 \
		--icon "$(APP_NAME).app" 175 120 \
		--hide-extension "$(APP_NAME).app" \
		--app-drop-link 425 120 \
		"build/$(APP_NAME)-$(VERSION).dmg" \
		"build/$(APP_NAME).app" || true

zip: app
	cd build && zip -r $(APP_NAME)-$(VERSION).zip $(APP_NAME).app

release: zip
	@echo "Build complete: build/$(APP_NAME)-$(VERSION).zip"
	@shasum -a 256 build/$(APP_NAME)-$(VERSION).zip

test:
	swift test

clean:
	rm -rf .build
	rm -rf build
	rm -rf *.xcodeproj