#!/bin/bash

URL="https://nexcis-auth.web.app"
APP_NAME="Nexcis Auth"

# Function to check for emulator
check_emulator() {
  if ! adb devices | grep -q "emulator"; then
    echo "Error: No emulator detected. Please start an Android emulator first."
    exit 1
  fi
}

# Function to launch the app
launch_app() {
  echo "Launching $APP_NAME as a WebApp"
  
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
}

# Function to create a home screen shortcut
create_shortcut() {
  echo "Creating home screen shortcut for $APP_NAME"
  
  adb shell am start \
    -n "com.android.chrome/com.google.android.apps.chrome.Main" \
    -d "$URL" \
    --es "create_shortcut" "true" \
    --es "shortcut_name" "$APP_NAME"
    
  echo "Shortcut created. You should see it on the emulator's home screen."
}

# Function to clear data
clear_data() {
  echo "Clearing Chrome data for a fresh start..."
  adb shell pm clear com.android.chrome
  echo "Chrome data cleared."
}

# Main menu
show_menu() {
  echo "========================="
  echo "  NEXCIS WEBVIEW TOOLS"
  echo "========================="
  echo "1) Launch $APP_NAME"
  echo "2) Create home screen shortcut"
  echo "3) Clear Chrome data"
  echo "4) Exit"
  echo "========================="
  echo "Enter your choice [1-4]: "
  read choice
  
  case $choice in
    1) launch_app ;;
    2) create_shortcut ;;
    3) clear_data ;;
    4) exit 0 ;;
    *) echo "Invalid option. Please try again." ;;
  esac
}

# Check for emulator first
check_emulator

# If no arguments, show menu
if [ $# -eq 0 ]; then
  show_menu
else
  # Handle command line arguments
  case "$1" in
    launch) launch_app ;;
    shortcut) create_shortcut ;;
    clear) clear_data ;;
    *)
      echo "Usage: $0 [launch|shortcut|clear]"
      echo "Or run without arguments for interactive menu"
      exit 1
      ;;
  esac
fi 