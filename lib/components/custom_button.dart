import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onTap, required this.buttonText});
  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
