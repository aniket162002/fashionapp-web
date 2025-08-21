# Firebase SMS Setup Guide

## 🚨 **Current Issue: Test Phone Number Blocking Real SMS**

I can see from your Firebase Console screenshot that you have a test phone number configured:
- Phone: `+91 98193 99470`
- Code: `123456`

This is why you're not receiving real SMS messages!

## 🔧 **Fix Steps:**

### **Step 1: Remove Test Phone Number (CRITICAL)**
1. Go to Firebase Console → Authentication → Settings
2. Scroll to "Phone numbers for testing"
3. **DELETE** the test number `+91 98193 99470`
4. Click "Save"

### **Step 2: Enable Real SMS Sending**
1. Go to Firebase Console → Authentication → Sign-in method
2. Click on "Phone" provider
3. Ensure it's **Enabled**
4. Remove any test phone numbers
5. Save changes

### **Step 3: Configure Billing (Required for SMS)**
1. Go to Firebase Console → Settings → Usage and billing
2. **Upgrade to Blaze Plan** (Pay-as-you-go)
3. This is REQUIRED for sending real SMS messages
4. SMS costs: ~$0.01-0.05 per message

### **Step 4: Test with Real Phone Number**
1. Use your actual phone number (not the test number)
2. You should receive real SMS messages
3. Enter the actual OTP code from SMS

## ⚠️ **Important Notes:**

- **Test numbers prevent real SMS** - Remove them completely
- **Billing required** - Free tier doesn't send real SMS
- **Real phone numbers only** - Use actual mobile numbers
- **SMS charges apply** - Small cost per message

## 🧪 **Testing After Setup:**
1. Remove test phone number from Firebase Console
2. Use real phone number in app
3. Should receive actual SMS with OTP code
4. Enter real OTP code (not 123456)

This will fix the SMS sending issue!