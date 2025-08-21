@echo off
echo ========================================
echo Flutter Android Build Test
echo ========================================

echo.
echo 1. Checking Java version...
java -version
echo.

echo 2. Checking JAVA_HOME...
echo JAVA_HOME: %JAVA_HOME%
echo.

echo 3. Running Flutter Doctor...
flutter doctor -v
echo.

echo 4. Cleaning previous builds...
flutter clean
cd android
call gradlew clean
cd ..
echo.

echo 5. Building APK (Debug)...
flutter build apk --debug

echo.
echo ========================================
echo Build Test Complete!
echo ========================================

if %ERRORLEVEL% EQU 0 (
    echo ✅ BUILD SUCCESSFUL!
    echo APK Location: build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo ❌ BUILD FAILED!
    echo Check the error messages above.
)

pause