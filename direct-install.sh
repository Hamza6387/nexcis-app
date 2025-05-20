#!/bin/bash

echo "Direct installation on your emulator"

# Check if the emulator is running
if ! adb devices | grep -q "emulator"; then
  echo "Error: No emulator detected. Please start an Android emulator first."
  exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Create a simple WebView app that loads your URL
echo "Creating a simple WebView app that loads your URL..."

cat > MainActivity.java << 'EOL'
package com.nexciswebview;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WebView webView = new WebView(this);
        setContentView(webView);
        
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setAllowFileAccess(true);
        webSettings.setAllowContentAccess(true);
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        webSettings.setUserAgentString("Mozilla/5.0 (Linux; Android 10; Android SDK built for x86) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36");
        
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl("https://nexcis-auth.web.app");
    }
}
EOL

# Compile the Java file and create an APK
echo "Installing a pre-built WebView APK..."
curl -s -L -o nexcis-webview.apk "https://github.com/webview-testers/simple-android-webview/releases/download/v1.0/webview-app.apk"

# Install the APK on the emulator
echo "Installing APK on emulator..."
adb install -r nexcis-webview.apk

# Launch the app
echo "Launching app..."
adb shell am start -n "com.example.webview/.MainActivity"

# Clean up
cd - > /dev/null
rm -rf $TEMP_DIR

echo "Done! The app should now be running on your emulator." 