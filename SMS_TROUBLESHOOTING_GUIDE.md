# SMS OTP Troubleshooting Guide

## 🚨 **Main Issue: Test Phone Number Blocking Real SMS**

### **Problem:**
You have a test phone number configured in Firebase Console that prevents real SMS from being sent.

### **Solution:**
1. **Remove Test Phone Number:**
   - Go to Firebase Console → Authentication → Settings
   - Find "Phone numbers for testing" section
   - **DELETE** the entry: `+91 98193 99470` with code `123456`
   - Click "Save"

2. **Enable Billing (REQUIRED):**
   - Go to Firebase Console → Settings → Usage and billing
   - Upgrade to **Blaze Plan** (Pay-as-you-go)
   - Free tier cannot send real SMS messages

## 🔧 **Error Message Improvements Made:**

### **Before (Technical):**
- "FirebaseAuthException: invalid-verification-code"
- "auth/session-expired: The verification session has expired"

### **After (User-Friendly):**
- "Wrong OTP code. Please check and try again"
- "OTP expired. Please request a new code"
- "No internet connection. Please try again"

## 📱 **Testing Steps:**

### **Step 1: Clean Firebase Setup**
1. Remove ALL test phone numbers from Firebase Console
2. Ensure Phone Authentication is enabled
3. Upgrade to Blaze plan for real SMS

### **Step 2: Test with Real Phone**
1. Use your actual phone number (not +91 98193 99470)
2. Click "Send OTP"
3. Wait 1-2 minutes for SMS
4. Enter the actual OTP code from SMS

### **Step 3: Verify Error Handling**
1. Enter wrong OTP code
2. Should see: "Wrong OTP code. Please check and try again"
3. Wait for OTP to expire
4. Should see: "OTP expired. Please request a new code"

## 🎯 **Expected Behavior After Fix:**

### **Registration Screen:**
1. Select "Phone (OTP)"
2. Enter real phone number
3. Click "Send OTP"
4. Modal appears with SMS delivery info
5. Receive actual SMS on phone
6. Enter real OTP code
7. See green verification badge

### **Password Reset Screen:**
1. Select "Phone (OTP)"
2. Enter real phone number
3. Click "Verify Phone Number"
4. Modal appears with SMS delivery info
5. Receive actual SMS on phone
6. Enter real OTP code
7. See green verification badge
8. Button changes to "Continue to Reset Password"

## ⚠️ **Important Notes:**

- **Test numbers block real SMS** - Must be removed
- **Billing required** - Free tier = no real SMS
- **SMS costs** - ~$0.01-0.05 per message
- **Delivery time** - 1-2 minutes for SMS arrival
- **Real phone only** - Use actual mobile numbers

## 🔍 **Common Issues:**

### **"OTP not received"**
- Check if test phone number is removed
- Verify billing is enabled
- Wait 2-3 minutes for SMS
- Check spam/blocked messages

### **"Wrong OTP code"**
- Use actual code from SMS (not 123456)
- Check if code expired (60 seconds)
- Request new OTP if needed

### **"Service unavailable"**
- Check internet connection
- Verify Firebase project settings
- Try again after few minutes

The main fix is removing the test phone number from Firebase Console!