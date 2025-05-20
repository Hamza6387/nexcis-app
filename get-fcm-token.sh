#!/bin/bash

echo "===== Getting FCM Token for NexcisWebViewApp ====="

# Clean any old builds
echo "Cleaning previous builds..."
cd android && chmod +x gradlew && ./gradlew clean

# Build the app
echo "Building the Android app with FCM token modules..."
./gradlew assembleDebug

# Check if build succeeded
if [ $? -ne 0 ]; then
    echo "Build failed. Please check the logs for errors."
    cd ..
    exit 1
fi

cd ..

# Install the app on the emulator
echo "Installing app on emulator..."
adb uninstall com.nexciswebviewapp || true
adb install -r android/app/build/outputs/apk/debug/app-debug.apk

# Clear logcat
echo "Clearing logcat..."
adb logcat -c

# Launch the app
echo "Launching app..."
adb shell am start -n com.nexciswebviewapp/.MainActivity

# Wait for app to initialize
echo "Waiting for app to initialize..."
sleep 5

# Print FCM token logs
echo "Showing FCM token logs:"
adb logcat | grep -E "FCM|Firebase|token|FCMTokenModule|Notifications" --color=auto 