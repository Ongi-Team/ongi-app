import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/core/constants/constants.dart';
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: BasicTextField(
                        label: '전화번호',
                        hintText: '전화번호를 입력해주세요.',
                        controller: vm.phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: vm.canSendCode && !vm.isSendingCode
                            ? vm.sendVerificationCode
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: OngiColor.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          disabledForegroundColor: OngiColor.systemGray03,
                        ),
                        child: vm.isSendingCode
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: OngiColor.primary,
                                ),
                              )
                            : Text(
                                vm.isCodeSent ? '재발송' : '인증번호 발송',
                                style: OngiTextStyle.body15.copyWith(
                                  color: vm.canSendCode
                                      ? OngiColor.primary
                                      : OngiColor.systemGray03,
                                ),
                              ),
                      ),
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
                        SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: vm.verificationCodeController.text
                                        .trim()
                                        .isEmpty ||
                                    vm.isVerifyingPhone ||
                                    vm.isPhoneVerified
                                ? null
                                : vm.verifyPhone,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: OngiColor.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              disabledForegroundColor: OngiColor.systemGray03,
                            ),
                            child: vm.isVerifyingPhone
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: OngiColor.primary,
                                    ),
                                  )
                                : Text(
                                    '인증 확인',
                                    style: OngiTextStyle.body15.copyWith(
                                      color: vm.verificationCodeController.text
                                                  .trim()
                                                  .isEmpty ||
                                              vm.isPhoneVerified
                                          ? OngiColor.systemGray03
                                          : OngiColor.primary,
                                    ),
                                  ),
                          ),
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
                const Spacer(),
                BasicButton(
                  text: '다음',
                  onPressed: () => context.push(AppRoutes.signupAccountInfo),
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
