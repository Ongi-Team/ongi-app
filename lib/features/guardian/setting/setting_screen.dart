import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:ongi_app/features/guardian/setting/setting_view_model.dart';

class GuardianSettingScreen extends StatelessWidget {
  const GuardianSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SettingViewModel();
    final menuItems = viewModel.getMenuItems(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 상단 로고 및 타이틀
              SvgPicture.asset(
                'assets/logo.svg',
                height: 28,
              ),
              const SizedBox(height: 24),
              const Text(
                '설정',
                style: OngiTextStyle.subTitle,
              ),
              const SizedBox(height: 32),

              // 설정 메뉴 리스트
              Expanded(
                child: ListView.separated(
                  physics:
                      const NeverScrollableScrollPhysics(), // 리스트가 짧으므로 스크롤 고정
                  itemCount: menuItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildSettingTile(item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(SettingMenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: OngiTextStyle.body15,
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}
