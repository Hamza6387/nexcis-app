package com.nexciswebviewapp;

import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;

public class FCMTokenModule extends ReactContextBaseJavaModule {
    private static final String TAG = "FCMTokenModule";

    public FCMTokenModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "FCMTokenModule";
    }

    @ReactMethod
    public void getToken(final Promise promise) {
        Log.d(TAG, "Requesting FCM token directly through native module");
        
        try {
            FirebaseMessaging.getInstance().getToken()
                    .addOnCompleteListener(new OnCompleteListener<String>() {
                        @Override
                        public void onComplete(@NonNull Task<String> task) {
                            if (!task.isSuccessful()) {
                                Log.w(TAG, "Fetching FCM registration token failed", task.getException());
                                promise.reject("FCM_ERROR", "Failed to get FCM token: " + 
                                        (task.getException() != null ? task.getException().getMessage() : "Unknown error"));
                                return;
                            }

                            // Get new FCM registration token
                            String token = task.getResult();
                            Log.d(TAG, "FCM Token: " + token);
                            promise.resolve(token);
                        }
                    });
        } catch (Exception e) {
            Log.e(TAG, "Error getting FCM token", e);
            promise.reject("FCM_ERROR", "Error getting FCM token: " + e.getMessage());
        }
    }
} 