#!/bin/bash

URL="https://nexcis-auth.web.app"
APP_NAME="Nexcis Auth"

echo "Launching $APP_NAME as a WebApp"

# Check if emulator is running
if ! adb devices | grep -q "emulator"; then
  echo "Error: No emulator detected. Please start an Android emulator first."
  exit 1
fi

# Force stop Chrome if it's running
echo "Closing any existing Chrome instances..."
adb shell am force-stop com.android.chrome

# Launch Chrome with the URL in fullscreen mode
echo "Launching $URL in Chrome..."
adb shell am start \
  -n "com.android.chrome/com.google.android.apps.chrome.Main" \
  -d "$URL" \
  --ez "create_shortcut" "true" \
  --es "shortcut_name" "$APP_NAME" \
  --es "webapp" "true" \
  --ez "from_homescreen" "true"

echo "Launch complete. The app should now be running on your emulator."
echo ""
echo "You can relaunch the app anytime with:"
echo "./launch-webapp.sh" 