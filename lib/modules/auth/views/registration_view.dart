import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/auth_controller.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // Country Code State
  String _selectedCountryCode = '+49'; // Default Germany
  final List<Map<String, String>> _countries = [
    {'code': '+49', 'flag': '🇩🇪'}, // Germany
    {'code': '+92', 'flag': '🇵🇰'}, // Pakistan
    {'code': '+1', 'flag': '🇺🇸'}, // USA
    {'code': '+44', 'flag': '🇬🇧'}, // UK
    {'code': '+33', 'flag': '🇫🇷'}, // France
    {'code': '+91', 'flag': '🇮🇳'}, // India
    {'code': '+81', 'flag': '🇯🇵'}, // Japan
    {'code': '+86', 'flag': '🇨🇳'}, // China
    {'code': '+971', 'flag': '🇦🇪'}, // UAE
    {'code': '+90', 'flag': '🇹🇷'}, // Turkey
  ];

  // Timer State
  int _timerSeconds = 60; // Extended to 1 minute as requested
  bool _canResend = false;
  late final Timer _timer; // Standard Timer

  // Colors
  static const primaryColor = Color(0xFFFFC105);
  static const backgroundDark = Color(0xFF181610);
  static const surfaceDark = Color(0xFF2A261C);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var n in _otpFocusNodes) n.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 60; // Reset to 60s
      _canResend = false;
    });
    // Standard Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        if (mounted) setState(() => _timerSeconds--);
      } else {
        _timer.cancel();
        if (mounted) setState(() => _canResend = true);
      }
    });
  }

  // Inject Controller
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  void _onSendCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Format: Remove spaces/dashes to match standard E.164 format
    final numberBody = _phoneController.text.replaceAll(RegExp(r'\s+'), '');
    final fullNumber = "$_selectedCountryCode$numberBody";

    _authController.verifyPhoneNumber(fullNumber);

    if (_canResend) _startTimer();
  }

  void _onVerify() {
    String otp = _otpControllers.map((e) => e.text).join();
    print("DEBUG OTP: |$otp|"); // Check for spaces or missing digits
    if (otp.length < 6) {
      Get.snackbar("Error", "Please enter the complete 6-digit code");
      return;
    }

    _authController.verifyOtp(otp);
  }

  // Helper to format time 00:30
  String get _timerText {
    final minutes = (_timerSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: ListView.builder(
            itemCount: _countries.length,
            itemBuilder: (context, index) {
              final country = _countries[index];
              return ListTile(
                leading: Text(
                  country['flag']!,
                  style: TextStyle(fontSize: 24.sp),
                ),
                title: Text(
                  country['code']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedCountryCode = country['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- Background Gradient (Subtle) ---
          Positioned.fill(child: Container(color: backgroundDark)),

          // --- Main Content (Scrollable) ---
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 48.h,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top App Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white70,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                            const SizedBox(), // Removed Skip button for production
                          ],
                        ),

                        SizedBox(height: 40.h),

                        // Headline
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(text: "Access the "),
                              TextSpan(
                                text: "Glow",
                                style: TextStyle(
                                  color: primaryColor,
                                  shadows: [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 15.r,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Your personal sun awaits. Enter your mobile number to begin your journey.",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Phone Input
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 58.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color:
                                Colors.transparent, // Transparent as requested
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Country Code Picker
                              GestureDetector(
                                onTap: _showCountryPicker,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.public,
                                        color: primaryColor,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _selectedCountryCode,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.expand_more,
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        size: 18.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Container(
                                width: 1.w,
                                height: 28.h,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              SizedBox(width: 16.w),

                              // Input Field (Full Width)
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Colors.transparent,
                                  decoration: InputDecoration(
                                    hintText: "152 040 0000",
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      bottom: 2.h,
                                    ),
                                    errorStyle: TextStyle(
                                      height: 0,
                                    ), // Hide default error text to keep layout clean
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty)
                                      return "";
                                    if (value.trim().length < 7) return "";
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Send Code Button (Moved Below)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: TextButton(
                              onPressed: _onSendCode,
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: const Text(
                                "Send Code",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.h,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "VERIFICATION",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.h,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // OTP Input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Enter 6-digit Code",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _canResend
                                  ? "Resend Available"
                                  : "Resend in $_timerText",
                              style: TextStyle(
                                color: _canResend
                                    ? primaryColor
                                    : Colors.white.withValues(alpha: 0.4),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            final isFocused = _otpFocusNodes[index].hasFocus;
                            return Container(
                              width: 50.w, // Slightly wider
                              height: 64.h, // Increased height as requested
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Transparent as requested
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isFocused
                                      ? primaryColor
                                      : Colors.white.withOpacity(0.1),
                                  width: isFocused ? 1.5.w : 1.w,
                                ),
                                boxShadow: isFocused
                                    ? [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.1),
                                          blurRadius: 10.r,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength:
                                      6, // Allow pasting full code (we handle single char logic in onChanged)
                                  cursorColor: primaryColor,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) {
                                    // Paste Logic (Only for first field or if pasting full code)
                                    if (value.length == 6) {
                                      for (int i = 0; i < 6; i++) {
                                        _otpControllers[i].text = value[i];
                                      }
                                      _otpFocusNodes[5]
                                          .requestFocus(); // Focus last
                                      setState(() {});
                                      return;
                                    }

                                    // Standard Input Logic
                                    if (value.isNotEmpty && index < 5) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      _otpFocusNodes[index - 1].requestFocus();
                                    }
                                    setState(() {});
                                  },
                                  onTap: () => setState(() {}),
                                ),
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: 16.h),
                        Center(
                          child: GestureDetector(
                            onTap: _canResend
                                ? () {
                                    _onSendCode();
                                    setState(() {});
                                  }
                                : null,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 12.sp,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Didn't receive the code? ",
                                  ),
                                  TextSpan(
                                    text: "Resend now",
                                    style: TextStyle(
                                      color: _canResend
                                          ? primaryColor
                                          : Colors.white.withValues(alpha: 0.2),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //  const Spacer(),
                        SizedBox(height: 40.h),

                        // Verify Button
                        Container(
                          width: double.infinity,
                          height: 56.h, // Slightly reduced height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.3),
                                blurRadius: 20.r,
                                offset: Offset(0, 8.h),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _onVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: backgroundDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "VERIFY & CREATE ACCOUNT",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward_ios, size: 16.sp),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: Text(
                            "By continuing, you agree to our Terms of Service and Privacy Policy.",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
