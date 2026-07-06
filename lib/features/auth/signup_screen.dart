import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/firestore_service.dart';
import '../../core/widgets/animated_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glowing_logo.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/premium_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
  Future<void> signup() async {
  if (!_formKey.currentState!.validate()) return;

  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match"),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
await userCredential.user!.updateDisplayName(
  nameController.text.trim(),
);

await userCredential.user!.reload();

await FirestoreService.createUserProfile();

await userCredential.user!.sendEmailVerification();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Account created successfully! Please verify your email.",
        ),
      ),
    );

    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message = "This email is already registered.";
        break;

      case 'invalid-email':
        message = "Please enter a valid email.";
        break;

      case 'weak-password':
        message = "Password must be at least 6 characters.";
        break;

      default:
        message = e.message ?? "Signup failed.";
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
  _controller.dispose();

  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();

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
                  constraints: const BoxConstraints(
                    maxWidth: 460,
                  ),
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
                        "Create Account",
                        style: AppTextStyles.displayLarge,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Join StudyFlow and start learning today.",
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
                              children: [

                                PremiumTextField(
                                  controller: nameController,
                                  hint: "Full Name",
                                  icon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter your name";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                PremiumTextField(
                                  controller: emailController,
                                  hint: "Email Address",
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter email";
                                    }
                                    if (!value.contains("@")) {
                                      return "Invalid email";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                PremiumTextField(
                                  controller: passwordController,
                                  hint: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return "Minimum 6 characters";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                PremiumTextField(
                                  controller: confirmPasswordController,
                                  hint: "Confirm Password",
                                  icon: Icons.lock_reset_outlined,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Confirm password";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 28),

                                AnimatedButton(
                                  text: "CREATE ACCOUNT",
                                  loading: loading,
                                  icon: Icons.person_add_alt_1,
                                  onPressed: signup,
                                ),

                                const SizedBox(height: 20),

                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Already have an account? Login",
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