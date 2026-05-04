import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/styles.dart';
import 'package:ongi_app/core/constants/colors.dart';

class ElderlyNavigation extends StatelessWidget {
  const ElderlyNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const Color _activeColor = OngiColor.primary;
  static const Color _inactiveColor = OngiColor.systemGray03;
  static const Color _backgroundColor = OngiColor.white50;

  static const List<_NavItem> _items = [
    _NavItem(
      iconOn: 'assets/icons/nav/hone_on.svg',
      iconOff: 'assets/icons/nav/home_off.svg',
      label: '홈',
    ),
    _NavItem(
      iconOn: 'assets/icons/nav/setting_on.svg',
      iconOff: 'assets/icons/nav/setting_off.svg',
      label: '설정',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _backgroundColor,
        border: Border(
          top: BorderSide(color: OngiColor.systemGray02, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: _activeColor,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        isSelected ? item.iconOn : item.iconOff,
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: OngiTextStyle.nav.copyWith(
                          color: isSelected ? _activeColor : _inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.iconOn,
    required this.iconOff,
    required this.label,
  });

  final String iconOn;
  final String iconOff;
  final String label;
}
