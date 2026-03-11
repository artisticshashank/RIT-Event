import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/auth/widgets/auth_field.dart';
import 'package:autonexa/features/auth/widgets/social_login_button.dart';
import '../controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            context: context,
          );
    }
  }

  void navigateToSignup() {
    Routemaster.of(context).push('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adapt layout to the main Pallete theme
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final accentColor = Pallete.secondaryColor;
    final mainTextColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Logo/Icon
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons
                                  .stacked_line_chart_rounded, // Stand-in for the stacked lines logo
                              size: 48,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AutoNexa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: mainTextColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Welcome Texts
                      Text(
                        'Welcome Back to AutoNexa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter valid user name & password\nto continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      AuthField(
                        label: 'Email',
                        hintText: 'Email Address',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Please enter your email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      AuthField(
                        label: 'Password',
                        hintText: 'Enter Password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        isObscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: subTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Please enter your password';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Remember Me
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val ?? false;
                                });
                              },
                              activeColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: subTextColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              color: mainTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Log In Button
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: subTextColor.withValues(alpha: 0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: subTextColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Social Logins
                      Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Google',
                              icon: Icons.g_mobiledata,
                              iconColor: Colors.blue,
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Apple',
                              icon: Icons.apple,
                              iconColor: mainTextColor,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // Footer Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Haven't any account? ",
                            style: TextStyle(
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: navigateToSignup,
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
