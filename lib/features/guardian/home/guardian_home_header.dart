import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/constants.dart';

class GuardianHomeHeader extends StatelessWidget {
  const GuardianHomeHeader({
    super.key,
    required this.dateText,
    required this.name,
    required this.greeting,
  });

  final String dateText;
  final String name;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/logo.svg',
          height: 28,
        ),
        const SizedBox(height: 16),
        Text(dateText, style: OngiTextStyle.body15),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              height: 1.3,
            ),
            children: [
              TextSpan(
                text: '$name님',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '의 일정이에요'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          greeting,
          style: OngiTextStyle.body15.copyWith(
            color: OngiColor.systemGray03,
          ),
        ),
      ],
    );
  }
}
