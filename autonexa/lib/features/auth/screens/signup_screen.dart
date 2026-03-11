import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/auth/widgets/auth_field.dart';
import 'package:autonexa/features/auth/widgets/social_login_button.dart';
import '../controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProviderCategory _selectedRole = ProviderCategory.regular_user;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signup() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
            role: _selectedRole,
            context: context,
          );
    }
  }

  void navigateToLogin() {
    Routemaster.of(context).push('/');
  }

  Widget _buildRoleCard(ProviderCategory role, String title, IconData icon) {
    bool isSelected = _selectedRole == role;
    final accentColor = Pallete.secondaryColor;
    final inputColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : inputColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white60
                        : Colors.black54),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white60
                          : Colors.black54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                              Icons.person_add_alt_1_rounded,
                              size: 48,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Join AutoNexa',
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

                      Text(
                        'Create an Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register to manage your high-\nperformance garage easily',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),

                      Text(
                        'Select Role',
                        style: TextStyle(
                          color: subTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildRoleCard(
                              ProviderCategory.regular_user,
                              "User",
                              Icons.person,
                            ),
                            _buildRoleCard(
                              ProviderCategory.mechanic,
                              "Mechanic",
                              Icons.build,
                            ),
                            _buildRoleCard(
                              ProviderCategory.parts_seller,
                              "Seller",
                              Icons.shopping_cart,
                            ),
                            _buildRoleCard(
                              ProviderCategory.towing_agency,
                              "Towing",
                              Icons.local_shipping,
                            ),
                            _buildRoleCard(
                              ProviderCategory.petrol_bunk,
                              "Fuel Station",
                              Icons.local_gas_station,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      AuthField(
                        label: 'Full Name',
                        hintText: 'John Doe',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Please enter your name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AuthField(
                        label: 'Email',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Please enter your email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

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
                          if (val.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: signup,
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
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: navigateToLogin,
                            child: Text(
                              'Log in',
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
