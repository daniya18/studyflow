import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../../core/widgets/animated_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glowing_logo.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/premium_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  bool loading = false;

  late final AnimationController _controller;

  late final Animation<double> fadeAnimation;

  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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
  Future<void> sendResetLink() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    loading = true;
  });

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.mark_email_read_rounded,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Text("Email Sent"),
          ],
        ),
        content: Text(
          "A password reset link has been sent to\n\n${emailController.text.trim()}\n\nPlease check your inbox and spam folder.",
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = "No account exists with this email.";
        break;

      case 'invalid-email':
        message = "Please enter a valid email.";
        break;

      case 'too-many-requests':
        message = "Too many requests. Try again later.";
        break;

      default:
        message = e.message ?? "Something went wrong.";
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text("Reset Failed"),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
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
void dispose() {
  emailController.dispose();
  _controller.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
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
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: [

                      const SizedBox(height: 20),

                      const Hero(
                        tag: "studyflow_logo",
                        child: GlowingLogo(
                          size: 110,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "Forgot Password?",
                        style: AppTextStyles.displayLarge,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Enter your registered email to receive a password reset link.",
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

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
                                  controller: emailController,
                                  hint: "Email Address",
                                  icon: Icons.email_outlined,
                                  keyboardType:
                                      TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return "Email is required";
                                    }

                                    if (!value.contains("@")) {
                                      return "Enter a valid email";
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 30),

                                AnimatedButton(
                                  text: "SEND RESET LINK",
                                  loading: loading,
                                  icon: Icons.send_rounded,
                                  onPressed: sendResetLink,
                                ),

                                const SizedBox(height: 20),

                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        AppColors.primary,
                                    side: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 54),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                  ),
                                  label: const Text(
                                    "Back to Login",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "StudyFlow © 2026",
                        style: AppTextStyles.caption,
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
}}