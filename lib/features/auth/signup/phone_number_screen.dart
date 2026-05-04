import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'signup_view_model.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

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
                  subtitle: '본인 인증을 위한 전화번호를 입력해주세요',
                  onBackButtonPressed: () => context.pop(),
                ),
                const SizedBox(height: 40),

                BasicTextField(
                  label: '전화번호',
                  hintText: '전화번호를 입력해주세요.',
                  controller: vm.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                BasicTextField(
                  label: '인증번호',
                  hintText: '인증번호를 입력해주세요.',
                  controller: vm.verificationCodeController,
                  keyboardType: TextInputType.number,
                ),

                const Spacer(),

                BasicButton(
                  text: '다음',
                  onPressed: () =>
                      context.push(AppRoutes.signupAccountInfo),
                  isClickable: vm.canProceedFromPhone,
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
