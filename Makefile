osx_image: xcode61
language: objective-c

WORKSPACE = ARCollectionViewMasonryLayout.xcworkspace
SCHEME = Demo
DEVICE_HOST = platform='iOS Simulator',OS='7.1',name='iPhone 4s'

all: ci

build:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator -destination $(DEVICE_HOST) build | xcpretty -c

clean:
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) clean

test:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug test -sdk iphonesimulator -destination $(DEVICE_HOST)| xcpretty -c --test

ci: build
