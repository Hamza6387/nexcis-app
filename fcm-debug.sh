#!/bin/bash

# Clear Chrome and logs
echo "Clearing Chrome data and logs..."
adb shell pm clear com.android.chrome
adb logcat -c

# Launch the WebView
echo "Launching Nexcis Auth WebView..."
./webview-tools.sh launch &

# Wait a moment for the app to start
sleep 3

# Monitor logs for FCM related messages
echo "Monitoring logs for FCM token registration..."
echo "Press Ctrl+C to stop monitoring"
adb logcat | grep -E "FCM|Firebase|Notifications|token|google.firebase.messaging|com.nexciswebviewapp|MyFirebaseMessagingService" --color=auto 