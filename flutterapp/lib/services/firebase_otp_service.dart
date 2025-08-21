import 'package:firebase_auth/firebase_auth.dart';
import 'package:active_ecommerce_cms_demo_app/other_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

// Conditional import for platform-specific JavaScript helpers
import 'mobile_js_helper.dart' if (dart.library.js) 'web_js_helper.dart';

class FirebaseOTPService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static ConfirmationResult? _webConfirmationResult;
  static String? _verificationId;

  // Debug logging helper
  static void _debugLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Send OTP
  static Future<bool> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function() onVerificationCompleted,
    Function(String)? onVerificationFailed,
  }) async {
    try {
      _debugLog('🔥 Sending OTP to: $phoneNumber');

      if (kIsWeb) {
        _debugLog('🌐 Web platform detected - using signInWithPhoneNumber');

        // Clear any previous verification data
        _webConfirmationResult = null;

        try {
          // Clear any existing reCAPTCHA
          _clearWebRecaptcha();

          // Wait a moment for cleanup
          await Future.delayed(Duration(milliseconds: 500));

          _debugLog('🔄 Attempting to send OTP with fresh reCAPTCHA...');

          // Web OTP using ConfirmationResult and reCAPTCHA handled internally
          _webConfirmationResult = await _auth.signInWithPhoneNumber(
            phoneNumber,
          );

          if (_webConfirmationResult != null) {
            _debugLog('✅ Web OTP sent successfully');
            onCodeSent('code-sent-web');
            return true;
          } else {
            _debugLog('❌ Failed to get confirmation result');
            onError('Failed to send OTP. Please try again.');
            return false;
          }
        } on FirebaseAuthException catch (e) {
          _debugLog('❌ Firebase Auth Error: ${e.code} - ${e.message}');

          if (e.code == 'invalid-app-credential' ||
              e.code == 'captcha-check-failed') {
            _debugLog(
              '❌ reCAPTCHA verification failed. This is a known issue with Firebase Web.',
            );
            _debugLog(
              '💡 Suggesting user to refresh the page or try mobile app.',
            );

            onError(
              'Phone verification is having issues on web browser.\n\nPlease try:\n1. Refresh this page (F5)\n2. Clear browser cache\n3. Try in incognito mode\n4. Use mobile app if available',
            );
            return false;
          } else {
            rethrow;
          }
        }
      } else {
        // Mobile OTP using verifyPhoneNumber
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            onVerificationCompleted();
          },
          verificationFailed: (FirebaseAuthException e) {
            final error = e.message ?? "Verification failed";
            if (onVerificationFailed != null) {
              onVerificationFailed(error);
            } else {
              onError(error);
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            onCodeSent(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
          timeout: const Duration(seconds: 60),
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _debugLog('❌ Firebase Auth Error: ${e.code} - ${e.message}');

      // Enhanced error handling for release mode
      String errorMessage = _getFirebaseErrorMessage(e);
      onError(errorMessage);
      return false;
    } catch (e) {
      _debugLog('❌ Unexpected error: $e');
      onError('Network error. Please check your connection and try again.');
      return false;
    }
  }

  /// Verify OTP
  static Future<bool> verifyOTP({
    required String otpCode,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      if (kIsWeb) {
        if (_webConfirmationResult == null) {
          onError("Session expired. Please request OTP again.");
          return false;
        }
        final userCredential = await _webConfirmationResult!.confirm(
          otpCode.trim(),
        );
        if (userCredential.user != null) {
          onSuccess();
          return true;
        } else {
          onError("Verification failed. Please try again.");
          return false;
        }
      } else {
        if (_verificationId == null) {
          onError("Verification ID not found. Please request OTP again.");
          return false;
        }
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otpCode.trim(),
        );
        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          onSuccess();
          return true;
        } else {
          onError("Verification failed. Please try again.");
          return false;
        }
      }
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }

  /// Format phone number for Firebase
  static String formatPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!cleaned.startsWith('+')) {
      cleaned = '${OtherConfig.defaultPhoneCountryCode}$cleaned';
    }
    return cleaned;
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    RegExp phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(cleaned);
  }

  /// Resend OTP
  static Future<bool> resendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function() onVerificationCompleted,
  }) async {
    // Clear previous verification data
    _verificationId = null;
    _webConfirmationResult = null;

    return await sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
      onVerificationCompleted: onVerificationCompleted,
    );
  }

  /// Utility methods
  static String? getVerificationId() => _verificationId;

  static void clearVerificationData() {
    _verificationId = null;
    _webConfirmationResult = null;
  }

  static User? getCurrentUser() => _auth.currentUser;
  static bool isUserSignedIn() => _auth.currentUser != null;

  static Future<void> signOut() async {
    await _auth.signOut();
    clearVerificationData();
  }

  /// Clear web reCAPTCHA to prevent token conflicts
  static void _clearWebRecaptcha() {
    if (kIsWeb) {
      try {
        WebJSHelper.clearRecaptcha();
      } catch (e) {
        _debugLog('⚠️ Could not clear reCAPTCHA: $e');
      }
    }
  }

  /// Get user-friendly error messages for Firebase Auth errors
  static String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Please enter a valid phone number with country code';
      case 'too-many-requests':
        return 'Too many attempts. Please wait 5 minutes and try again';
      case 'quota-exceeded':
        return 'SMS limit reached. Please try again later';
      case 'invalid-verification-code':
        return 'Wrong OTP code. Please check and try again';
      case 'invalid-verification-id':
      case 'session-expired':
        return 'OTP expired. Please request a new code';
      case 'invalid-app-credential':
        return 'App verification failed. This is a release mode issue.\n\nPlease ensure:\n1. App is signed with correct certificate\n2. SHA-256 fingerprint is added to Firebase\n3. Google Play Integrity is properly configured';
      case 'captcha-check-failed':
        return 'Security verification failed. This may be due to Play Integrity checks.\n\nPlease try:\n1. Restart the app\n2. Check internet connection\n3. Contact support if issue persists';
      case 'recaptcha-not-enabled':
        return 'Phone verification temporarily unavailable';
      case 'network-request-failed':
        return 'No internet connection. Please check and try again';
      case 'app-not-authorized':
        return 'App not authorized for Firebase. Please contact support';
      case 'missing-phone-number':
        return 'Please enter your phone number';
      case 'operation-not-allowed':
        return 'Phone verification not enabled. Contact support';
      case 'credential-already-in-use':
        return 'This phone number is already registered';
      case 'user-disabled':
        return 'Account disabled. Please contact support';
      default:
        // Enhanced error handling for Play Integrity issues
        String message = e.message ?? 'Something went wrong. Please try again';

        // Check for Play Integrity specific errors
        if (message.contains('Play Integrity') ||
            message.contains('app identifier') ||
            message.contains('reCAPTCHA checks were unsuccessful')) {
          return 'App verification failed. This is a known issue in release mode.\n\nSolutions:\n1. Ensure app is properly signed\n2. Add SHA-256 certificate to Firebase Console\n3. Enable Play Integrity API\n4. Try using debug version if available';
        }

        if (message.contains('Firebase') || message.contains('auth/')) {
          return 'Verification failed. Please try again';
        }
        return message;
    }
  }
}
