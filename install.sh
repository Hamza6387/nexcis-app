#!/bin/bash

echo "Building and installing NexcisWebViewApp"

# Go to the android directory
cd android

# Clean any previous builds
./gradlew clean

# Build the debug APK
./gradlew assembleDebug

# Get the path to the APK
APK_PATH="./app/build/outputs/apk/debug/app-debug.apk"

# Check if the APK was built successfully
if [ -f "$APK_PATH" ]; then
    echo "APK built successfully at $APK_PATH"
    
    # Install the APK on the connected device
    echo "Installing APK on device..."
    adb install -r "$APK_PATH"
    
    # Start the app
    echo "Starting the app..."
    adb shell monkey -p com.nexciswebviewapp -c android.intent.category.LAUNCHER 1
    
    echo "Installation complete!"
else
    echo "Error: APK not found at $APK_PATH"
    echo "Build may have failed. Check the logs for errors."
    exit 1
fi 