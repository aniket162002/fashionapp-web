import 'dart:async';
import 'package:active_ecommerce_cms_demo_app/custom/btn.dart';
import 'package:active_ecommerce_cms_demo_app/custom/input_decorations.dart';
import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/services/firebase_otp_service.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirebaseOTPVerification extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final VoidCallback onVerificationSuccess;
  final String title;
  final String subtitle;

  const FirebaseOTPVerification({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.onVerificationSuccess,
    this.title = "OTP Verification",
    this.subtitle = "Enter the verification code sent to your phone",
  });

  @override
  _FirebaseOTPVerificationState createState() => _FirebaseOTPVerificationState();
}

class _FirebaseOTPVerificationState extends State<FirebaseOTPVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _startResendTimer();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyOTP() async {
    if (_otpController.text.trim().length != 6) {
      ToastComponent.showDialog("Please enter a valid 6-digit OTP");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await FirebaseOTPService.verifyOTP(
      otpCode: _otpController.text.trim(),
      onSuccess: () {
        setState(() {
          _isLoading = false;
        });
        ToastComponent.showDialog("Phone number verified successfully!");
        widget.onVerificationSuccess();
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        ToastComponent.showDialog(error);
      },
    );
  }

  void _resendOTP() async {
    if (_resendCountdown > 0) return;

    setState(() {
      _isResending = true;
    });

    await FirebaseOTPService.resendOTP(
      phoneNumber: widget.phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          _isResending = false;
        });
        ToastComponent.showDialog("OTP sent successfully!");
        _startResendTimer();
      },
      onError: (error) {
        setState(() {
          _isResending = false;
        });
        ToastComponent.showDialog(error);
      },
      onVerificationCompleted: () {
        setState(() {
          _isResending = false;
        });
        ToastComponent.showDialog("Phone number verified automatically!");
        widget.onVerificationSuccess();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen_width = MediaQuery.of(context).size.width;
    
    return AuthScreen.buildScreen(
      context,
      widget.title,
      buildBody(context, screen_width),
    );
  }

  Column buildBody(BuildContext context, double screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        SizedBox(
          width: screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                widget.phoneNumber,
                style: TextStyle(
                  color: MyTheme.accent_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              
              // OTP Input Field
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Enter OTP",
                  style: TextStyle(
                    color: MyTheme.accent_color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "000000",
                    ).copyWith(
                      counterText: "",
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),

              // Verify Button
              SizedBox(
                height: 45,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Verify OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onPressed: _isLoading ? null : _verifyOTP,
                ),
              ),

              SizedBox(height: 20),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendCountdown == 0 && !_isResending ? _resendOTP : null,
                    child: Text(
                      _resendCountdown > 0
                          ? "Resend in ${_resendCountdown}s"
                          : _isResending
                              ? "Sending..."
                              : "Resend OTP",
                      style: TextStyle(
                        color: _resendCountdown == 0 && !_isResending
                            ? MyTheme.accent_color
                            : MyTheme.font_grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: _resendCountdown == 0 && !_isResending
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Change Phone Number",
                  style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
