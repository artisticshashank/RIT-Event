import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
