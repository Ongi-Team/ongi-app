import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/data/services/auth_service.dart';

// 설정 메뉴 아이템 모델
class SettingMenuItem {
  final String title;
  final VoidCallback onTap;

  SettingMenuItem({required this.title, required this.onTap});
}

class ElderSettingViewModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();

  // 메뉴 리스트 정의
  List<SettingMenuItem> getMenuItems(BuildContext context) {
    return [
      SettingMenuItem(
        title: '서비스이용약관',
        onTap: () => debugPrint('서비스이용약관 이동'),
      ),
      SettingMenuItem(
        title: '개인정보처리방침',
        onTap: () => debugPrint('개인정보처리방침 이동'),
      ),
      SettingMenuItem(
        title: '사용방법',
        onTap: () => debugPrint('사용방법 이동'),
      ),
      SettingMenuItem(
        title: '로그아웃',
        onTap: () => _showLogoutDialog(context),
      ),
    ];
  }

  // 회원탈퇴 다이얼로그 예시
  void _showLogoutDialog(BuildContext context) {
    final pageContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말로 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소')),
          TextButton(
            onPressed: () {
              _logout(pageContext, dialogContext);
            },
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(
    BuildContext pageContext,
    BuildContext dialogContext,
  ) async {
    try {
      await _authService.logout();
      if (!pageContext.mounted || !dialogContext.mounted) return;
      Navigator.pop(dialogContext);
      pageContext.go(AppRoutes.login);
    } catch (e) {
      if (!pageContext.mounted || !dialogContext.mounted) return;
      Navigator.pop(dialogContext);
      ScaffoldMessenger.of(pageContext).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
