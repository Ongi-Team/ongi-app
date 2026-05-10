import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/core/utils/phone_number_input_formatter.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'package:ongi_app/shared/widgets/check_action_button.dart';
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: BasicTextField(
                              label: '전화번호',
                              hintText: '전화번호를 입력해주세요.',
                              controller: vm.phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [PhoneNumberInputFormatter()],
                            ),
                          ),
                          const SizedBox(width: 8),
                          CheckActionButton(
                            text: vm.isCodeSent ? '재발송' : '인증번호 발송',
                            onPressed:
                                vm.canSendCode ? vm.sendVerificationCode : null,
                            isLoading: vm.isSendingCode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: BasicTextField(
                                  label: '인증번호',
                                  hintText: '인증번호를 입력해주세요.',
                                  controller: vm.verificationCodeController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CheckActionButton(
                                text: '인증 확인',
                                onPressed: vm.verificationCodeController.text
                                            .trim()
                                            .isEmpty ||
                                        vm.isPhoneVerified
                                    ? null
                                    : vm.verifyPhone,
                                isLoading: vm.isVerifyingPhone,
                              ),
                            ],
                          ),
                          if (vm.phoneVerifyMessage != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              vm.phoneVerifyMessage!,
                              style: OngiTextStyle.caption12.copyWith(
                                color: vm.isPhoneVerified
                                    ? OngiColor.success
                                    : OngiColor.fail,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: BasicButton(
                  text: '다음',
                  isClickable: vm.canProceedFromPhone,
                  onPressed: vm.canProceedFromPhone
                      ? () => context.push(AppRoutes.signupAccountInfo)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
