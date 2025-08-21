@echo off
echo ========================================
echo Flutter Release Build Script
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo ERROR: pubspec.yaml not found. Please run this script from the Flutter project root.
    pause
    exit /b 1
)

REM Check if keystore exists
if not exist "android\app\key.jks" (
    echo ERROR: Keystore file not found at android\app\key.jks
    echo Please ensure your keystore file is in the correct location.
    pause
    exit /b 1
)

REM Check if key.properties exists
if not exist "android\key.properties" (
    echo ERROR: key.properties file not found at android\key.properties
    echo Please ensure your key.properties file exists with keystore credentials.
    pause
    exit /b 1
)

echo Pre-build checks passed!
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo Step 2: Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    pause
    exit /b 1
)

echo Step 3: Building release APK...
echo This may take several minutes...
echo.
call flutter build apk --release --verbose
if %errorlevel% neq 0 (
    echo ERROR: Flutter build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Release APK location: build\app\outputs\flutter-apk\app-release.apk
echo.

REM Check if APK was created
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo APK file size:
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do echo %%~zA bytes
    echo.
    
    echo Next steps:
    echo 1. Install APK: flutter install --release
    echo 2. Test OTP functionality
    echo 3. If OTP fails, run get_sha256.bat to get certificate fingerprint
    echo 4. Add fingerprint to Firebase Console
    echo.
    
    set /p install="Do you want to install the APK now? (y/n): "
    if /i "%install%"=="y" (
        echo Installing release APK...
        call flutter install --release
        if %errorlevel% neq 0 (
            echo WARNING: Installation failed. Please install manually.
        ) else (
            echo Installation successful!
        )
    )
) else (
    echo ERROR: APK file was not created
    pause
    exit /b 1
)

echo.
echo Build process completed!
pause
