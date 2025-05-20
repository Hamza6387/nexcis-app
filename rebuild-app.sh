#!/bin/bash

echo "===== Rebuilding NexcisWebViewApp with Updated FCM Configuration ====="

# Clean any old builds
echo "Cleaning previous builds..."
cd android && ./gradlew clean

# Check if cleaning succeeded
if [ $? -ne 0 ]; then
    echo "Failed to clean Android build. Fixing permissions..."
    cd ..
    chmod +x android/gradlew
    cd android && ./gradlew clean
fi

# Build the app
echo "Building the Android app..."
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

# Launch the app
echo "Launching app..."
adb shell am start -n com.nexciswebviewapp/.MainActivity

echo "===== Build and deployment completed! ====="
echo "Check the logcat output for FCM token registration logs:"
echo "adb logcat | grep -E \"FCM|Firebase|Notifications|token|MyFirebaseMessagingService\" --color=auto" 