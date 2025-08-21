<?php

// Test script for phone registration API
// Run this after fixing the database to test the backend

$baseUrl = 'http://localhost/api/v2'; // Update with your actual API URL

// Test data
$testData = [
    'name' => 'Test User',
    'email_or_phone' => '+1234567890', // Use a valid phone number
    'password' => 'password123',
    'password_confirmation' => 'password123',
    'register_by' => 'phone'
];

// Test registration
echo "Testing Phone Registration...\n";
echo "URL: {$baseUrl}/auth/signup\n";
echo "Data: " . json_encode($testData, JSON_PRETTY_PRINT) . "\n\n";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $baseUrl . '/auth/signup');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($testData));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpCode\n";
echo "Response: " . json_encode(json_decode($response), JSON_PRETTY_PRINT) . "\n\n";

// If registration successful, test login
$responseData = json_decode($response, true);
if ($responseData && isset($responseData['result']) && $responseData['result'] === true) {
    echo "Registration successful! Testing login...\n";
    
    $loginData = [
        'email' => $testData['email_or_phone'],
        'password' => $testData['password'],
        'login_by' => 'phone'
    ];
    
    echo "Login Data: " . json_encode($loginData, JSON_PRETTY_PRINT) . "\n\n";
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $baseUrl . '/auth/login');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($loginData));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    
    $loginResponse = curl_exec($ch);
    $loginHttpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    echo "Login HTTP Code: $loginHttpCode\n";
    echo "Login Response: " . json_encode(json_decode($loginResponse), JSON_PRETTY_PRINT) . "\n";
} else {
    echo "Registration failed. Please check the error message above.\n";
}

echo "\n=== Test Complete ===\n";
echo "Next steps:\n";
echo "1. Fix any errors shown above\n";
echo "2. Test the complete flow in the Flutter app\n";
echo "3. Verify order tracking works in the app\n";

?>