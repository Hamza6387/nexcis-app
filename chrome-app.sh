#!/bin/bash

echo "Creating Chrome shortcut app for https://nexcis-auth.web.app"

# Check if emulator is running
if ! adb devices | grep -q "emulator"; then
  echo "Error: No emulator detected. Please start an Android emulator first."
  exit 1
fi

# Create a desktop shortcut for Chrome with your URL
echo "Creating Chrome shortcut in emulator..."
adb shell am start -n com.android.chrome/com.google.android.apps.chrome.Main \
  -d "https://nexcis-auth.web.app" \
  --es "create_shortcut" "true" \
  --es "shortcut_name" "Nexcis Auth"

echo "You can now open the Chrome app and access your website."
echo "To relaunch directly to the website, run:"
echo "adb shell am start -n com.android.chrome/com.google.android.apps.chrome.Main -d \"https://nexcis-auth.web.app\"" 