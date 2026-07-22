#!/bin/sh

set -eu

SCRIPT_DIRECTORY=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIRECTORY=$(dirname "$SCRIPT_DIRECTORY")

cd "$PROJECT_DIRECTORY"
flutter pub get
flutter build ios --config-only --no-codesign

echo "iOS 15.5 đã sẵn sàng. Mở ios/Runner.xcworkspace để chạy bằng Xcode."
