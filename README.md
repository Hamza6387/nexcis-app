# Nexcis App

Welcome to the Nexcis App!

This app is designed to open a webview and provide Firebase authentication on the login screen. Please follow the instructions below to set up and run the app.

---

## Features
- Opens a webview to the Nexcis authentication portal
- Google Sign-In via Firebase Authentication

---

## Setup & Run Instructions

### Prerequisites
- Node.js (v14 or above recommended)
- npm or yarn
- Android Studio (for Android build/emulator)
- Java JDK 8 or above
- Git

### 1. Clone the Repository
```
git clone https://github.com/Hamza6387/nexcis-app.git
cd nexcis-app
```

### 2. Install Dependencies
```
npm install
# or
yarn install
```

### 3. Android Setup
- Open Android Studio and run an emulator, or connect a physical device with USB debugging enabled.
- Make sure you have the correct Android SDKs installed.

### 4. Run the App
```
npx react-native run-android
```

The app will launch and display a login screen with Google Sign-In (see below).

---

## Login Screen

![Login Screen](assets/login-screen.png)

---

## Notes
- The app opens a webview pointing to: [https://nexcis-auth.web.app](https://nexcis-auth.web.app)
- Users must sign in with their Google account to proceed.
- If you encounter any issues, please check your environment setup or contact the developer.

---

Thank you for reviewing the Nexcis App!