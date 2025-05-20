#!/bin/bash
URL=${1:-"https://nexcis-auth.web.app"}
adb shell am start -n "io.github.webview.sample/.MainActivity" --es "url" "$URL"
