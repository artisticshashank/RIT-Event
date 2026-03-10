import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final String label;
  final Widget? rightLabel;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isObscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.label,
    this.rightLabel,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.isObscure = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputColor = Theme.of(context).cardColor;
    final mainTextColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: subTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (rightLabel != null) rightLabel!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: mainTextColor),
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: subTextColor),
            prefixIcon: Icon(prefixIcon, color: mainTextColor),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: inputColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 24,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
