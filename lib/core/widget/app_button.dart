import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String title;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? const SizedBox.shrink() : Icon(icon ?? Icons.check),
        label: isLoading ? const CircularProgressIndicator() : Text(title),
      ),
    );
  }
}
