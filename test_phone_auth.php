<?php
/**
 * Phone Authentication Test Script
 * 
 * This script can be used to test the phone authentication fixes
 * Run this after deploying the fixes to verify functionality
 */

// Test data
$testPhone = "+1234567890";
$testPassword = "testpass123";
$testName = "Test User";

echo "=== Phone Authentication Test Script ===\n\n";

// Test 1: Phone Registration
echo "1. Testing Phone Registration...\n";
$registrationData = [
    'name' => $testName,
    'email_or_phone' => $testPhone,
    'password' => $testPassword,
    'password_confirmation' => $testPassword,
    'register_by' => 'phone',
    'g-recaptcha-response' => ''
];

echo "Registration payload: " . json_encode($registrationData, JSON_PRETTY_PRINT) . "\n";
echo "Expected: User created with phone field populated and email_verified_at set\n\n";

// Test 2: Phone Login
echo "2. Testing Phone Login...\n";
$loginData = [
    'email' => $testPhone,
    'password' => $testPassword,
    'login_by' => 'phone',
    'identity_matrix' => 'your_purchase_code_here',
    'temp_user_id' => ''
];

echo "Login payload: " . json_encode($loginData, JSON_PRETTY_PRINT) . "\n";
echo "Expected: Successful login without 'Identity matrix error'\n\n";

// Test 3: Phone Password Reset
echo "3. Testing Phone Password Reset...\n";
$passwordResetData = [
    'phone' => $testPhone,
    'password' => 'newpassword123'
];

echo "Password reset payload: " . json_encode($passwordResetData, JSON_PRETTY_PRINT) . "\n";
echo "Expected: Password updated successfully\n\n";

// Database queries to verify
echo "=== Database Verification Queries ===\n\n";

echo "1. Check user creation:\n";
echo "SELECT id, name, email, phone, email_verified_at FROM users WHERE phone = '$testPhone';\n\n";

echo "2. Check phone field index:\n";
echo "SHOW INDEX FROM users WHERE Column_name = 'phone';\n\n";

echo "3. Verify password update:\n";
echo "SELECT id, phone, updated_at FROM users WHERE phone = '$testPhone' ORDER BY updated_at DESC LIMIT 1;\n\n";

echo "=== API Endpoints to Test ===\n\n";
echo "POST /api/v2/auth/signup - Phone registration\n";
echo "POST /api/v2/auth/login - Phone login\n";
echo "POST /api/v2/auth/password/phone_reset - Phone password reset\n\n";

echo "=== Flutter App Testing Steps ===\n\n";
echo "1. Open registration screen\n";
echo "2. Select 'Phone (OTP)' option\n";
echo "3. Enter phone number and verify OTP\n";
echo "4. Complete registration\n";
echo "5. Try logging in with phone number\n";
echo "6. Test forget password with phone OTP\n\n";

echo "=== Expected Results ===\n\n";
echo "✓ No 'Identity matrix error' on phone login\n";
echo "✓ No reCAPTCHA errors on mobile devices\n";
echo "✓ Phone users can register and login successfully\n";
echo "✓ Phone password reset works without email code input\n";
echo "✓ All flows redirect properly after completion\n\n";

echo "Test script completed. Deploy the fixes and run these tests manually.\n";
?>