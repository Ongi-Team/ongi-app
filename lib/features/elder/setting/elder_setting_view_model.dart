import 'package:flutter/material.dart';

// 설정 메뉴 아이템 모델
class SettingMenuItem {
  final String title;
  final VoidCallback onTap;

  SettingMenuItem({required this.title, required this.onTap});
}

class ElderSettingViewModel extends ChangeNotifier {
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말로 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              debugPrint('로그아웃');
              Navigator.pop(context);
            },
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
