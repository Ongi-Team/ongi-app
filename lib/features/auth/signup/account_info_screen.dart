import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'signup_view_model.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicAppBar(
                  title: '회원가입',
                  subtitle: '사용하실 아이디와 비밀번호를 입력해주세요',
                  onBackButtonPressed: () => context.pop(),
                ),
                const SizedBox(height: 40),
                BasicTextField(
                  label: '아이디',
                  hintText: '사용하실 아이디를 입력해주세요',
                  controller: vm.idController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                BasicTextField(
                  label: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                  controller: vm.passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                BasicTextField(
                  label: '비밀번호 확인',
                  hintText: '비밀번호 확인을 위해 다시 입력해주세요.',
                  controller: vm.confirmPasswordController,
                  obscureText: true,
                ),
                if (vm.passwordMatchError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    vm.passwordMatchError!,
                    style: OngiTextStyle.body15.copyWith(
                      color: OngiColor.fail,
                    ),
                  ),
                ],
                if (vm.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    vm.errorMessage!,
                    style: OngiTextStyle.body15.copyWith(
                      color: OngiColor.fail,
                    ),
                  ),
                ],
                const Spacer(),
                BasicButton(
                  text: '다음',
                  onPressed: () => context.push(AppRoutes.signupElderlyInfo),
                  isClickable: vm.canProceedFromAccountInfo,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
