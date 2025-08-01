#!/bin/bash
xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphoneos -configuration Debug
strip build/Debug-iphoneos/bad_queue_app.app/bad_queue_app
mkdir build/Debug-iphoneos/Payload
mv build/Debug-iphoneos/bad_queue_app.app build/Debug-iphoneos/Payload
ditto -c -k --sequesterRsrc --keepParent build/Debug-iphoneos/Payload aquila-app.ipa
