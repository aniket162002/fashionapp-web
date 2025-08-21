# Phone Registration Flow Fix Guide

## Issues Fixed

### 1. Database Issue - Missing `expires_at` Column
**Problem**: The `personal_access_tokens` table is missing the `expires_at` column that Laravel Sanctum requires.

**Solution**: 
1. Run the SQL script to add the missing column:
```sql
-- Execute this in your database
ALTER TABLE `personal_access_tokens` 
ADD COLUMN `expires_at` TIMESTAMP NULL DEFAULT NULL 
AFTER `abilities`;
```

2. Or run the migration when database is available:
```bash
php artisan migrate
```

### 2. Backend Logic Issue - Phone Registration Flow
**Problem**: The AuthController had conflicting logic that was overriding the phone verification status.

**Fixed**: Updated the signup method in `app/Http/Controllers/Api/V2/AuthController.php` to:
- Properly handle phone registration separately from email registration
- Mark phone-registered users as verified immediately (since Firebase OTP already verified the phone)
- Remove conflicting email verification logic for phone users

### 3. Complete Phone Registration Flow

#### Frontend (Flutter App):
1. **Registration Screen** (`flutterapp/lib/screens/auth/registration.dart`):
   - User selects "Phone (OTP)" registration method
   - Enters name, phone number, and password
   - Clicks "Send OTP" button
   - Firebase OTP service sends SMS verification code
   - OTP verification modal appears

2. **OTP Verification** (`flutterapp/lib/widgets/otp_verification_modal.dart`):
   - User enters 6-digit OTP code
   - Firebase verifies the OTP
   - On successful verification, phone is marked as verified
   - User can now complete registration

3. **Complete Registration**:
   - User clicks "Sign Up" button
   - App calls backend API with verified phone number
   - Backend creates user account and returns access token
   - User is redirected to home screen

#### Backend (Laravel API):
1. **Signup Endpoint** (`/api/v2/auth/signup`):
   - Validates input data
   - Creates new user with phone number
   - Sets `email_verified_at` for phone users (since phone is already verified)
   - Returns access token for immediate login

2. **Login Endpoint** (`/api/v2/auth/login`):
   - Allows login with phone number and password
   - Returns access token for authenticated sessions

## Testing the Flow

### 1. Database Setup
First, ensure the database table is fixed:
```sql
-- Check if column exists
DESCRIBE personal_access_tokens;

-- If expires_at column is missing, add it:
ALTER TABLE `personal_access_tokens` 
ADD COLUMN `expires_at` TIMESTAMP NULL DEFAULT NULL 
AFTER `abilities`;
```

### 2. Test Phone Registration
1. Open the Flutter app
2. Go to Registration screen
3. Select "Phone (OTP)" option
4. Enter:
   - Name: "Test User"
   - Phone: Valid phone number with country code
   - Password: "password123"
   - Confirm Password: "password123"
5. Click "Send OTP"
6. Enter the received OTP code
7. Click "Sign Up"
8. Should redirect to home screen with user logged in

### 3. Test Phone Login
1. Go to Login screen
2. Select "Phone" login method
3. Enter registered phone number and password
4. Should login successfully

## API Endpoints

### Registration
```
POST /api/v2/auth/signup
Content-Type: application/json

{
  "name": "Test User",
  "email_or_phone": "+1234567890",
  "password": "password123",
  "password_confirmation": "password123",
  "register_by": "phone"
}
```

### Login
```
POST /api/v2/auth/login
Content-Type: application/json

{
  "email": "+1234567890",
  "password": "password123",
  "login_by": "phone"
}
```

## Expected Response Format
```json
{
  "result": true,
  "message": "Successfully logged in",
  "access_token": "1|abc123...",
  "token_type": "Bearer",
  "expires_at": null,
  "user": {
    "id": 1,
    "type": "customer",
    "name": "Test User",
    "email": null,
    "avatar": null,
    "avatar_original": null,
    "phone": "+1234567890",
    "email_verified": true
  }
}
```

## Troubleshooting

### If registration fails with "Column not found: expires_at":
- Run the SQL script to add the missing column
- Restart your web server after database changes

### If OTP is not received:
- Check Firebase configuration
- Ensure phone number includes country code
- Try using a different phone number
- Check SMS delivery in Firebase Console

### If user creation fails:
- Check database connection
- Verify all required fields are provided
- Check for duplicate phone numbers in database

### If login fails after registration:
- Ensure phone number format matches exactly
- Check password is correct
- Verify user exists in database with correct phone number

## Files Modified

1. `app/Http/Controllers/Api/V2/AuthController.php` - Fixed phone registration logic
2. `database/migrations/2024_08_20_000001_add_expires_at_to_personal_access_tokens_table.php` - Added migration for missing column
3. `fix_personal_access_tokens.sql` - SQL script to manually fix database

## Next Steps

1. **Run the database fix** (SQL script or migration)
2. **Test the complete flow** from registration to login
3. **Verify order tracking** works in the app (already implemented)
4. **Deploy to production** after testing

The phone registration flow should now work properly from Flutter app to backend!