import 'package:flutter/material.dart';
import 'package:ongi_app/core/enums/user_role.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'role_select_view_model.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleSelectViewModel(),
      child: const _RoleSelectView(),
    );
  }
}

class _RoleSelectView extends StatelessWidget {
  const _RoleSelectView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoleSelectViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(
                title: '사용자 계정을 선택해주세요',
                subtitle: '계정에 따라 다른 화면으로 진행됩니다',
                onBackButtonPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 100),

              // 보호자 버튼
              BasicButton(
                onPressed: () => vm.selectRole(UserRole.GUARDIAN),
                text: '보호자',
                isClickable: vm.selectedRole == UserRole.GUARDIAN,
              ),
              const SizedBox(height: 16),

              // 어르신 버튼
              BasicButton(
                onPressed: () => vm.selectRole(UserRole.ELDER),
                text: '어르신',
                isClickable: vm.selectedRole == UserRole.ELDER,
              ),

              const Spacer(),

              // 다음 버튼 (role 선택 후 활성화)
              BasicButton(
                text: '다음',
                isClickable: vm.selectedRole != null,
                onPressed: vm.selectedRole == null
                    ? null
                    : () => vm.confirm(
                          context: context,
                          onGuardian: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.guardianHome,
                          ),
                          onElder: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.elderHome,
                          ),
                        ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
