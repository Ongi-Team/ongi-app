import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/constants.dart';

class BasicAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBackButtonPressed;

  const BasicAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/left_arrow.svg'),
          onPressed: onBackButtonPressed,
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft, // 왼쪽 정렬
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0), // 왼쪽 정렬을 위한 패딩 값
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: OngiTextStyle.subTitle),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: OngiTextStyle.body15
                      .copyWith(color: OngiColor.systemGray03)),
            ],
          ),
        ),
      ],
    );
  }
}
