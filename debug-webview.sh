#!/bin/bash

URL="https://nexcis-auth.web.app"
APP_NAME="Nexcis Auth Debug"

# Function to check for emulator
check_emulator() {
  if ! adb devices | grep -q "emulator"; then
    echo "Error: No emulator detected. Please start an Android emulator first."
    exit 1
  fi
}

# Function to clear data
clear_data() {
  echo "Clearing Chrome data for a fresh start..."
  adb shell pm clear com.android.chrome
  echo "Chrome data cleared."
}

# Function to launch in debug mode
launch_debug() {
  echo "Launching $APP_NAME in debug mode"
  
  # Force stop Chrome if it's running
  echo "Closing any existing Chrome instances..."
  adb shell am force-stop com.android.chrome
  
  # Enable remote debugging
  adb shell "settings put global webview_remote_debugging 1"
  
  # Launch Chrome with the URL and debugging flags
  echo "Launching $URL in Chrome with debugging enabled..."
  adb shell am start \
    -n "com.android.chrome/com.google.android.apps.chrome.Main" \
    -d "$URL" \
    --ez "enable_remote_debugging" "true" \
    --ez "create_shortcut" "true" \
    --es "shortcut_name" "$APP_NAME" \
    --es "webapp" "true" \
    --ez "from_homescreen" "true"
    
  echo "Launch complete. The app should now be running on your emulator."
  echo "To access remote debugging, open chrome://inspect in Chrome on your computer."
}

# Check for emulator first
check_emulator

# Clear data first
clear_data

# Launch in debug mode
launch_debug 