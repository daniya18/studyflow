import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'phone_login_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glowing_logo.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/premium_textfield.dart';
import '../../core/widgets/social_button.dart';
import '../../core/services/google_sign_in_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import '../../core/services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;

  bool loginLoading = false;
  bool googleLoading = false;

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
    loadRememberMe();
  }
Future<void> loadRememberMe() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      emailController.text = prefs.getString('email') ?? '';
    }
  });
}

Future<void> saveRememberMe() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('rememberMe', rememberMe);

  if (rememberMe) {
    await prefs.setString(
      'email',
      emailController.text.trim(),
    );
  } else {
    await prefs.remove('email');
  }
}
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loginLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await saveRememberMe();
if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardScreen(),
  ),
);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
        ),
      );

      // TODO: Navigate to Dashboard

    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      switch (e.code) {
        case 'user-not-found':
          message = "No account found with this email.";
          break;

        case 'wrong-password':
          message = "Incorrect password.";
          break;

        case 'invalid-email':
          message = "Invalid email address.";
          break;

        case 'invalid-credential':
          message = "Invalid email or password.";
          break;

        case 'too-many-requests':
          message = "Too many attempts. Try again later.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          loginLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
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

Hero(
  tag: "studyflow_logo",
  child: GlowingLogo(
    size: 110,
  ),
),

const SizedBox(height: 30),

Text(
  "Welcome Back",
  textAlign: TextAlign.center,
  style: AppTextStyles.displayLarge,
),

const SizedBox(height: 12),

Text(
  "Continue your learning journey with StudyFlow",
  textAlign: TextAlign.center,
  style: AppTextStyles.body,
),

const SizedBox(height: 40),

GlassCard(
  child: Padding(
    padding: const EdgeInsets.all(28),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Text(
            "Login",
            style: AppTextStyles.heading,
          ),

          const SizedBox(height: 25),

          PremiumTextField(
            controller: emailController,
            hint: "Email Address",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }

              if (!value.contains("@")) {
                return "Enter a valid email";
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          PremiumTextField(
            controller: passwordController,
            hint: "Password",
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              if (value.length < 6) {
                return "Minimum 6 characters";
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Checkbox(
                    value: rememberMe,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),

                  const Text(
                    "Remember Me",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          AnimatedButton(
            text: "LOGIN",
            loading: loginLoading,
            icon: Icons.arrow_forward_rounded,
            onPressed: login,
          ),

          const SizedBox(height: 28),

          Row(
            children: [

              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(.15),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "OR",
                  style: AppTextStyles.bodySmall,
                ),
              ),

              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(.15),
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),
          SocialButton(
  text: "Continue with Google",
  isLoading: googleLoading,
  icon: Image.asset(
    "assets/images/google_logo.png",
    width: 24,
    height: 24,
  ),
  
  onPressed: () async {
    try {
      setState(() {
        googleLoading = true;
      });

      final userCredential =
          await GoogleSignInService.signInWithGoogle();

      if (!mounted) return;

      setState(() {
        googleLoading = false;
      });

     if (userCredential != null) {
  await FirestoreService.createUserProfile();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Welcome ${userCredential.user?.displayName ?? ''}",
      ),
    ),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const DashboardScreen(),
    ),
  );
}
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        googleLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Google Sign-In failed. Please try again.",
          ),
        ),
      );
    }
  },
),

const SizedBox(height: 30),

Wrap(
  alignment: WrapAlignment.center,
  crossAxisAlignment: WrapCrossAlignment.center,
  spacing: 4,
  children: [
    Text(
      "Don't have an account?",
      style: AppTextStyles.bodySmall,
    ),
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SignupScreen(),
          ),
        );
      },
      child: Text(
        "Create Account",
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 10),

Center(
  child: Text(
    "StudyFlow © 2026",
    style: AppTextStyles.caption,
  ),
),
const SizedBox(height: 16),

SocialButton(
  text: "Continue with Phone",
  icon: const Icon(
    Icons.phone_android_rounded,
    color: Colors.green,
    size: 24,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhoneLoginScreen(),
      ),
    );
  },
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