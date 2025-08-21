# reCAPTCHA Error Fix Guide

## 🚨 **Current Error:**
```
invalid-app-credential - The phone verification request contains an invalid application verifier. The reCAPTCHA token response is either invalid or expired.
```

## 🔧 **Root Cause:**
The reCAPTCHA token used by Firebase for web phone authentication is expiring or becoming invalid, causing the verification to fail.

## ✅ **Fixes Applied:**

### **1. Retry Mechanism in Firebase OTP Service:**
- Added automatic retry (up to 3 attempts) for reCAPTCHA failures
- 2-second delay between retries to allow reCAPTCHA to refresh
- Better error handling for `invalid-app-credential` errors

### **2. Enhanced Web Index.html:**
- Added automatic reCAPTCHA cleanup on page visibility changes
- Better error handling for expired tokens
- Added refresh helper function for reCAPTCHA issues

### **3. User-Friendly Error Messages:**
- "Security verification failed. Please refresh the page and try again"
- "Security check failed. Please try again"
- Removed technical Firebase error messages

## 🎯 **How the Fix Works:**

### **Before Fix:**
1. User clicks "Send OTP"
2. reCAPTCHA token expires
3. Firebase throws `invalid-app-credential` error
4. User sees technical error message
5. Process fails completely

### **After Fix:**
1. User clicks "Send OTP"
2. If reCAPTCHA token expires, system automatically retries
3. Up to 3 retry attempts with fresh tokens
4. If still fails, shows user-friendly message
5. User can refresh page and try again

## 🔍 **Additional Solutions:**

### **Solution 1: Firebase Console Check**
1. Go to Firebase Console → Authentication → Sign-in method
2. Ensure Phone provider is **enabled**
3. Check that your domain (`localhost`) is in authorized domains
4. Save changes and wait 5-10 minutes for propagation

### **Solution 2: Clear Browser Cache**
1. Open browser developer tools (F12)
2. Right-click refresh button → "Empty Cache and Hard Reload"
3. Or use Ctrl+Shift+R (Chrome) / Cmd+Shift+R (Mac)

### **Solution 3: Test in Incognito Mode**
1. Open incognito/private browsing window
2. Test OTP functionality
3. This eliminates cached reCAPTCHA tokens

### **Solution 4: Check Network/Firewall**
1. Ensure `googleapis.com` is not blocked
2. Check if corporate firewall blocks reCAPTCHA
3. Try different network if possible

## 📱 **Testing Steps:**

### **Step 1: Clear Everything**
1. Close all browser tabs
2. Clear browser cache
3. Open fresh browser window

### **Step 2: Test OTP Flow**
1. Go to registration/password reset
2. Select "Phone (OTP)"
3. Enter phone number
4. Click "Send OTP"
5. Wait for reCAPTCHA (if appears)
6. Check for success/error messages

### **Step 3: If Error Persists**
1. Refresh the page (F5)
2. Try again immediately
3. Check browser console for detailed errors
4. Try incognito mode

## ⚠️ **Important Notes:**

- **reCAPTCHA tokens expire quickly** (2-3 minutes)
- **Page refresh clears expired tokens**
- **Multiple tabs can cause conflicts**
- **Network issues affect reCAPTCHA**

## 🚀 **Expected Behavior After Fix:**

1. **First Attempt**: Should work normally
2. **If reCAPTCHA Fails**: Automatic retry (up to 3 times)
3. **If Still Fails**: User-friendly error message
4. **User Action**: Refresh page and try again
5. **Success**: OTP modal appears and SMS is sent

The retry mechanism should handle most reCAPTCHA token expiry issues automatically!