@echo off
echo ========================================
echo Firebase SHA-256 Fingerprint Generator
echo ========================================

echo.
echo Generating SHA-256 fingerprint for Firebase Console...
echo.

cd flutterapp\android

echo Running Gradle signing report...
call gradlew signingReport

echo.
echo ========================================
echo INSTRUCTIONS:
echo ========================================
echo 1. Look for "SHA256:" in the output above
echo 2. Copy the fingerprint (long string with colons)
echo 3. Go to Firebase Console: https://console.firebase.google.com/
echo 4. Select project: priyafashion-1a790
echo 5. Go to Project Settings (gear icon)
echo 6. Select "Your apps" tab
echo 7. Find Android app: com.example.active_ecommerce_cms_demo_app
echo 8. Click "Add fingerprint"
echo 9. Paste SHA-256 (remove colons if needed)
echo 10. Click "Save"
echo 11. Wait 5-10 minutes for changes to propagate
echo 12. Rebuild and test: flutter build apk --debug
echo ========================================

pause