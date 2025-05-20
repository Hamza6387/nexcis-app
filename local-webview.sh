#!/bin/bash

# Function to check for emulator
check_emulator() {
  if ! adb devices | grep -q "emulator"; then
    echo "Error: No emulator detected. Please start an Android emulator first."
    exit 1
  fi
}

# Function to clear Chrome data
clear_chrome() {
  echo "Clearing Chrome data..."
  adb shell pm clear com.android.chrome
  echo "Chrome data cleared."
}

# Function to push the HTML file to emulator
push_html() {
  echo "Copying error-handler.html to emulator..."
  adb push error-handler.html /sdcard/Download/
  echo "File copied successfully!"
}

# Function to launch the local HTML file in Chrome
launch_local() {
  echo "Launching local HTML file in Chrome..."
  adb shell am force-stop com.android.chrome
  adb shell am start -n "com.android.chrome/com.google.android.apps.chrome.Main" \
    -d "file:///sdcard/Download/error-handler.html" \
    --ez "create_shortcut" "true" \
    --es "shortcut_name" "Nexcis Auth" \
    --es "webapp" "true"
    
  echo "Launch complete! The app should now be running with error handling."
}

# Main execution
echo "===== Starting Local WebView with Error Handling ====="
check_emulator
clear_chrome
push_html
launch_local 