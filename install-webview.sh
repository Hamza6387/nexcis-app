#!/bin/bash

# Download a pre-built WebView APK
curl -L -o webview-app.apk "https://github.com/webview-samples/simple-webview/releases/download/v1.0.0/webview-sample.apk"

# Install the APK on the emulator
adb install -r webview-app.apk

# Create a custom WebView URL launcher script
cat > launch-url.sh << 'EOL'
#!/bin/bash
URL=${1:-"https://nexcis-auth.web.app"}
adb shell am start -n "io.github.webview.sample/.MainActivity" --es "url" "$URL"
EOL

# Make the launch script executable
chmod +x launch-url.sh

echo "WebView app installed. Run './launch-url.sh' to open your URL in the WebView." 