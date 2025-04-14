import 'package:flutter/material.dart';
import 'package:lg_pilot/utils/colors.dart';

class PilotButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? fillColor;
  final Color? textColor;
  final TextStyle? textDecoration;
  const PilotButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fillColor,
    this.textColor,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor ?? ThemeColors.primaryTextColor,
          minimumSize: const Size(double.infinity, 10),
          backgroundColor: fillColor ?? ThemeColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        child: Text(text, style: textDecoration ?? TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
