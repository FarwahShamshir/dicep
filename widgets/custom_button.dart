// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'app_color.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CustomButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 18, color: AppColors.buttonTextColor),
      ),
    );
  }
}
