import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/custom_textfield.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/theme/pallete.dart';
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
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Pallete.primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Pallete.primaryColor
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Pallete.primaryColor.withOpacity(0.3),
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
              color: isSelected ? Colors.white : Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

    return Scaffold(
      appBar: AppBar(title: const Text('Join AutoNexa'), centerTitle: true),
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Who are you?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
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
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          isObscure: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: signup,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: navigateToLogin,
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
