import 'package:flutter/material.dart';
import 'otp_screen.dart';
import '../../core/services/phone_auth_service.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glowing_logo.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/premium_textfield.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen>
    with SingleTickerProviderStateMixin {

  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  late final AnimationController _controller;

  late final Animation<double> fadeAnimation;

  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, .12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    phoneController.dispose();
    _controller.dispose();
    super.dispose();
  }Future<void> sendOtp() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    loading = true;
  });

  await PhoneAuthService.verifyPhoneNumber(
    phoneNumber: "+91${phoneController.text.trim()}",

    verificationCompleted: (credential) async {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone verified automatically!"),
        ),
      );

      // TODO: Navigate to Dashboard
    },

    verificationFailed: (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Verification failed"),
        ),
      );
    },

    codeSent: (verificationId) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            verificationId: verificationId,
            phoneNumber: "+91 ${phoneController.text.trim()}",
          ),
        ),
      );
    },

    codeAutoRetrievalTimeout: (verificationId) {
      debugPrint("Auto retrieval timeout");
    },
  );
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: GradientBackground(

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),

              child: FadeTransition(

                opacity: fadeAnimation,

                child: SlideTransition(

                  position: slideAnimation,

                  child: ConstrainedBox(

                    constraints: const BoxConstraints(
                      maxWidth: 450,
                    ),

                      child: Column(

                        children: [

                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Hero(
                            tag: "studyflow_logo",
                            child: GlowingLogo(
                              size: 100,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Text(
                            "Phone Login",
                            style: AppTextStyles.displayLarge,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Login securely using your mobile number.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body,
                          ),

                          const SizedBox(height: 35),

                          GlassCard(

                            child: Padding(

                              padding: const EdgeInsets.all(28),

                              child: Form(

                                key: _formKey,

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    PremiumTextField(
  controller: phoneController,
  hint: "Phone Number",
  icon: Icons.phone_android_rounded,
  keyboardType: TextInputType.phone,
  prefixText: "+91 ",
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    if (value.trim().length != 10) {
      return "Enter a valid 10-digit phone number";
    }

    return null;
  },
),

const SizedBox(height: 28),

AnimatedButton(
  text: "SEND OTP",
  loading: loading,
  icon: Icons.arrow_forward_rounded,
  onPressed: sendOtp,
),

const SizedBox(height: 24),

Text(
  "We'll send a verification code via SMS.",
  textAlign: TextAlign.center,
  style: AppTextStyles.bodySmall,
),

const SizedBox(height: 18),

TextButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text(
    "Back to Login",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}