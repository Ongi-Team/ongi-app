import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'signup_view_model.dart';

class ElderlyInfoScreen extends StatelessWidget {
  const ElderlyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignupViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 0) {
            FocusScope.of(context).unfocus();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicAppBar(
                        title: '어르신 개인정보 입력',
                        subtitle: '어르신 정보를 입력해주세요',
                        onBackButtonPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 40),
                      BasicTextField(
                        label: '성함',
                        hintText: '어르신 성함을 입력해주세요.',
                        controller: vm.elderlyNameController,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 24),
                      BasicTextField(
                        label: '연령',
                        hintText: '어르신의 연령을 입력해주세요.',
                        controller: vm.elderlyAgeController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      BasicTextField(
                        label: '관계',
                        hintText: '어르신과의 관계를 입력해주세요.',
                        controller: vm.elderlyRelationController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: BasicButton(
                  text: vm.isLoading ? '가입 중...' : '다음',
                  onPressed: () => vm.submitSignup(
                    onSuccess: () => context.go(AppRoutes.signupComplete),
                  ),
                  isClickable: vm.canSubmitElderlyInfo && !vm.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
