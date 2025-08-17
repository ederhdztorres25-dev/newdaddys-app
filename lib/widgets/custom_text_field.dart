import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.secondary),
      obscureText: isPassword,
      maxLines: 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primary,
        hintText: hintText,
        hintStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.placeholderText,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.placeholderText),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        errorStyle: AppFonts.bodySmall.copyWith(color: AppColors.danger),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        isDense: true,
      ),
      keyboardType: keyboardType,
    );
  }
}
