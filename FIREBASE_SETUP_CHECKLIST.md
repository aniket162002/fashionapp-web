# Firebase Phone Authentication Setup Checklist

## 🚨 **CRITICAL: Firebase Console Configuration Required**

### **Step 1: Enable Phone Authentication**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `priyafashion-1a790`
3. Navigate to **Authentication** → **Sign-in method**
4. Find **Phone** provider and click **Enable**
5. Save changes

### **Step 2: Configure Web Domain**
1. In Phone provider settings
2. Add authorized domains:
   - `localhost` (for development)
   - `your-domain.com` (for production)

### **Step 3: Test Phone Numbers (Optional)**
1. Go to **Authentication** → **Settings**
2. Scroll to **Phone numbers for testing**
3. Add test numbers:
   - Phone: `+91 9819399470`
   - Code: `123456`

### **Step 4: Verify Project Settings**
- Project ID: `priyafashion-1a790`
- Web API Key: `AIzaSyAzB4o0mgGns8hzYt_OVQlsz5SqzCZN21k`
- Auth Domain: `priyafashion-1a790.firebaseapp.com`

## 🔍 **Common Error Solutions**

### **Error: "400 Bad Request"**
- ✅ Enable Phone Authentication in Firebase Console
- ✅ Add localhost to authorized domains
- ✅ Check project configuration

### **Error: "reCAPTCHA Enterprise config failed"**
- ✅ This is normal - it falls back to reCAPTCHA v2
- ✅ Ensure domains are properly configured
- ✅ Test with a real phone number

### **Error: "invalid-app-credential"**
- ✅ Check Firebase project settings
- ✅ Verify API keys match
- ✅ Ensure Phone Auth is enabled

## 🧪 **Testing Steps**

1. **Use Test Phone Number**: `+91 9819399470`
2. **Expected OTP Code**: `123456` (if configured in Firebase)
3. **Check Browser Console**: Look for detailed error messages
4. **Verify reCAPTCHA**: Should appear and be solvable

## 📱 **Production Checklist**

- [ ] Phone Authentication enabled in Firebase Console
- [ ] Production domain added to authorized domains
- [ ] Real phone numbers tested
- [ ] SMS quota configured
- [ ] Error handling implemented
- [ ] User feedback messages added

## 🔧 **Current Implementation Status**

- ✅ Firebase OTP Service implemented
- ✅ Web reCAPTCHA container configured
- ✅ Error handling added
- ✅ Registration & Password Reset integrated
- ⚠️ **PENDING**: Firebase Console configuration (REQUIRED)

## 🚀 **Next Steps**

1. **Configure Firebase Console** (most important)
2. Test with the provided phone number
3. Check browser console for detailed errors
4. Verify reCAPTCHA appears and works
5. Test on real device with real phone number