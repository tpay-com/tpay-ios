#!/usr/bin/sh

DERIVED_DIR=.docs-derived
DOCS_DIR=docs
ARCHIVE=$DERIVED_DIR/Build/Products/Debug-iphoneos/Tpay.doccarchive

xcodebuild docbuild \
    -scheme Tpay \
    -workspace Tpay.xcworkspace \
    -destination generic/platform=iOS \
    -derivedDataPath $DERIVED_DIR

$(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" \
    --hosting-base-path /$HOSTING_BASE_PATH \
    --output-path $DOCS_DIR

# Clean up
rm -rf $DERIVED_DIR