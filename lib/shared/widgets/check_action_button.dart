import 'package:flutter/material.dart';
import 'package:ongi_app/core/constants/constants.dart';

class CheckActionButton extends StatelessWidget {
  const CheckActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: enabled ? OngiColor.primary : OngiColor.systemGray03,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          disabledForegroundColor: OngiColor.systemGray03,
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: OngiColor.primary,
                ),
              )
            : Text(
                text,
                style: OngiTextStyle.body15.copyWith(
                  color: enabled ? OngiColor.primary : OngiColor.systemGray03,
                ),
              ),
      ),
    );
  }
}
