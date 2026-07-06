import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/phone_auth_service.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glowing_logo.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/services/firestore_service.dart';
import '../dashboard/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

Future<void> verifyOtp() async {
  if (otpController.text.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid 6-digit OTP"),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    await PhoneAuthService.verifyOTP(
      verificationId: widget.verificationId,
      smsCode: otpController.text.trim(),
    );

    if (!mounted) return;

    await FirestoreService.createUserProfile();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("Phone verified successfully!"),
  ),
);

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardScreen(),
  ),
);
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? "Invalid OTP"),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [

                const SizedBox(height: 20),

                const Hero(
                  tag: "studyflow_logo",
                  child: GlowingLogo(size: 100),
                ),

                const SizedBox(height: 30),

                Text(
                  "Verify OTP",
                  style: AppTextStyles.displayLarge,
                ),

                const SizedBox(height: 12),

                Text(
                  "Enter the 6-digit code sent to",
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 35),

                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [

                        Pinput(
                          controller: otpController,
                          length: 6,
                        ),

                        const SizedBox(height: 30),

                        AnimatedButton(
                          text: "VERIFY OTP",
                          loading: loading,
                          icon: Icons.verified,
                          onPressed: verifyOtp,
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                          ),
                        ),

                      ],
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
);
  }
}