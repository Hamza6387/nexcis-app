import React, { useEffect, useState } from 'react';
import { Platform, SafeAreaView, StatusBar, StyleSheet, BackHandler, Alert, NativeModules } from 'react-native';
import * as Notifications from 'expo-notifications';
import { WebView } from 'react-native-webview';

const { FCMTokenModule } = NativeModules;

export default function App() {
  const [webViewRef, setWebViewRef] = useState(null);
  const [fcmToken, setFcmToken] = useState(null);
  
  useEffect(() => {
    // Register for push notifications immediately when the app starts
    registerForPushNotificationsAsync();
    
    // Also try getting token directly from Firebase
    getNativeFCMToken();
    
    // Handle back button presses
    const backHandler = BackHandler.addEventListener('hardwareBackPress', handleBackPress);
    return () => backHandler.remove();
  }, []);

  const handleBackPress = () => {
    if (webViewRef) {
      webViewRef.goBack();
      return true;
    }
    return false;
  };

  // This function uses our native module to get the FCM token directly
  const getNativeFCMToken = async () => {
    try {
      console.log('📱 Attempting to get FCM token through native module...');
      
      if (FCMTokenModule) {
        const token = await FCMTokenModule.getToken();
        console.log('📱 Native FCM Token:', token);
        
        if (token) {
          setFcmToken(token);
          
          // Show the token in an alert for debugging
          Alert.alert('Native FCM Token', token);
          
          // You could send this token to your server
          // sendTokenToServer(token);
        }
      } else {
        console.log('❌ Native FCM Token module not available');
      }
    } catch (error) {
      console.log('❌ Error getting native FCM token:', error);
    }
  };

  const registerForPushNotificationsAsync = async () => {
    try {
      console.log('🔔 Attempting to get FCM token...');
      
      const { status: existingStatus } = await Notifications.getPermissionsAsync();
      console.log('📱 Existing permission status:', existingStatus);
      
      let finalStatus = existingStatus;

      if (existingStatus !== 'granted') {
        console.log('📱 Requesting permissions...');
        const { status } = await Notifications.requestPermissionsAsync();
        finalStatus = status;
        console.log('📱 New permission status:', finalStatus);
      }

      if (finalStatus !== 'granted') {
        console.log('❌ Failed to get permission for push notifications');
        Alert.alert('Notification Permission', 'Please enable notification permissions to receive updates.');
        return;
      }

      console.log('✅ Notification permission granted, getting token...');
      
      // METHOD 1: Try getting Expo Push Token (works with Expo's notification service)
      try {
        console.log('📱 Attempting to get Expo Push Token...');
        const expoPushTokenResponse = await Notifications.getExpoPushTokenAsync({
          projectId: '331609605171', // Use your Firebase project number here
        });
        const expoPushToken = expoPushTokenResponse.data;
        console.log('📱 Expo Push Token:', expoPushToken);
        
        // This is an Expo-formatted token, can be used with Expo's notification service
        if (expoPushToken) {
          console.log('✅ Successfully retrieved Expo Push Token');
          setFcmToken(expoPushToken);
          
          // You could send this token to your server
          // sendTokenToServer(expoPushToken);
          
          // Show the token in an alert for debugging
          Alert.alert('Expo Push Token', expoPushToken);
        }
      } catch (expoPushError) {
        console.log('❌ Error getting Expo push token:', expoPushError);
      }
      
      // METHOD 2: Try getting native Device Push Token (actual FCM token)
      try {
        console.log('📱 Attempting to get native Device Push Token...');
        const devicePushTokenResponse = await Notifications.getDevicePushTokenAsync();
        const devicePushToken = devicePushTokenResponse.data;
        
        console.log('📱 Device Push Token (FCM):', devicePushToken);
        
        // This is the actual Firebase FCM token
        if (devicePushToken) {
          console.log('✅ Successfully retrieved Device Push Token (FCM)');
          setFcmToken(devicePushToken);
          
          // You could send this token to your server
          // sendTokenToServer(devicePushToken);
          
          // Show the FCM token in an alert for debugging
          Alert.alert('FCM Token', devicePushToken);
        }
      } catch (devicePushError) {
        console.log('❌ Error getting device push token:', devicePushError);
        Alert.alert('FCM Token Error', `Error: ${devicePushError.message}`);
      }
    } catch (error) {
      console.log('❌ Error in registerForPushNotificationsAsync:', error);
      Alert.alert('Error', `FCM registration failed: ${error.message}`);
    }
  };

  // Script to inject into WebView to help with Firebase Auth sessions and potentially pass FCM token
  const injectScript = `
    (function() {
      window.ReactNativeWebView.postMessage(JSON.stringify({ type: 'pageLoaded', url: window.location.href }));
      
      // Make the FCM token available to the web app if needed
      window.FCM_TOKEN = ${JSON.stringify(fcmToken)};
      
      // Listen for Firebase Auth state changes
      if (window.firebase && window.firebase.auth) {
        firebase.auth().onAuthStateChanged(function(user) {
          if (user) {
            window.ReactNativeWebView.postMessage(JSON.stringify({ 
              type: 'authStateChanged', 
              user: { uid: user.uid, email: user.email }
            }));
          }
        });
      }
    })();
  `;

  const handleMessage = (event) => {
    try {
      const data = JSON.parse(event.nativeEvent.data);
      console.log('Message from WebView:', data);
      
      if (data.type === 'authStateChanged' && data.user) {
        console.log('User authenticated:', data.user);
        // You could request FCM token again after authentication if needed
        // registerForPushNotificationsAsync();
      }
      
      // Handle any token requests from the web app
      if (data.type === 'requestFcmToken') {
        console.log('Web app requested FCM token');
        if (fcmToken) {
          webViewRef.injectJavaScript(`
            window.FCM_TOKEN = ${JSON.stringify(fcmToken)};
            if (window.onFcmTokenReceived) {
              window.onFcmTokenReceived(${JSON.stringify(fcmToken)});
            }
          `);
        } else {
          // If no token yet, try to get one
          registerForPushNotificationsAsync();
          getNativeFCMToken();
        }
      }
    } catch (error) {
      console.log('Error parsing message from WebView:', error);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <WebView 
        ref={ref => setWebViewRef(ref)}
        source={{ uri: 'https://nexcis-auth.web.app' }} 
        style={{ flex: 1 }}
        injectedJavaScript={injectScript}
        onMessage={handleMessage}
        javaScriptEnabled={true}
        domStorageEnabled={true}
        startInLoadingState={true}
        mixedContentMode="compatibility"
        allowsBackForwardNavigationGestures
        sharedCookiesEnabled={true}
        thirdPartyCookiesEnabled={true}
        userAgent="Mozilla/5.0 (Linux; Android 10; Android SDK built for x86) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36"
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: Platform.OS === 'android' ? StatusBar.currentHeight : 0,
  },
});
