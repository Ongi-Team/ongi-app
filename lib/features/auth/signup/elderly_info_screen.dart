import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/constants/constants.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicAppBar(
                  title: '어르신 개인정보 입력',
                  subtitle: '어르신 정보를 입력해주세요',
                  onBackButtonPressed: () => context.pop(),
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
                const SizedBox(height: 24),

                BasicTextField(
                  label: '전화번호',
                  hintText: '어르신의 전화번호를 입력해주세요.',
                  controller: vm.elderlyPhoneController,
                  keyboardType: TextInputType.phone,
                ),

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
                  onPressed: () => vm.submitSignup(
                    onSuccess: () {
                      // TODO: 회원가입 완료 후 이동할 화면으로 변경
                    },
                  ),
                  isClickable: vm.canSubmitElderlyInfo && !vm.isLoading,
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
