import 'package:flutter/material.dart';
import 'package:ongi_app/core/constants/constants.dart';

const double _largeWidth = double.infinity;

class BasicButton extends StatelessWidget {
  final String text;
  final bool isClickable;
  final VoidCallback? onPressed;

  const BasicButton({
    super.key,
    required this.text,
    required this.isClickable,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _largeWidth,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isClickable ? OngiColor.primary : OngiColor.systemGray03,
          foregroundColor: isClickable ? OngiColor.white50 : OngiColor.white50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: OngiTextStyle.button18,
        ),
        child: Text(text),
      ),
    );
  }
}
