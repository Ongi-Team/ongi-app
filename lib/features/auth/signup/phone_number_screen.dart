import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                const BasicTextField(
                  hintText: '전화번호를 입력해주세요.',
                  label: '전화번호',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                const BasicTextField(
                  hintText: '인증번호를 입력해주세요.',
                  label: '인증번호',
                  keyboardType: TextInputType.number,
                ),

                const Spacer(),

                BasicButton(
                  text: '다음',
                  onPressed: () {
                    // TODO: 다음 페이지로 이동
                  },
                  isClickable: true,
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
