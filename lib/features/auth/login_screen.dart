import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 로고
              SvgPicture.asset(
                'assets/logo.svg',
                height: 72,
              ),

              const Spacer(flex: 2),

              // 아이디 입력
              BasicTextField(
                label: '아이디',
                hintText: '아이디를 입력해주세요.',
                controller: vm.idController,
                keyboardType: TextInputType.text,
                onChanged: (_) => context.read<LoginViewModel>().clearError(),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              BasicTextField(
                label: '비밀번호',
                hintText: '비밀번호를 입력해주세요.',
                controller: vm.passwordController,
                obscureText: true,
                onChanged: (_) => context.read<LoginViewModel>().clearError(),
              ),

              // 에러 메시지
              if (vm.errorMessage != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    vm.errorMessage!,
                    style: OngiTextStyle.body15.copyWith(
                      color: const Color(0xFFE53935),
                    ),
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () => vm.login(
                            onSuccess: () {
                              if (!context.mounted) return;
                              // TODO: role 정보 API 연동 후 elderHome으로 분기
                              context.go(AppRoutes.guardianHome);
                            },
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OngiColor.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: OngiColor.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('로그인',
                          style: OngiTextStyle.button18
                              .copyWith(color: OngiColor.white50)),
                ),
              ),
              const SizedBox(height: 12),

              // 회원가입 버튼
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 회원가입 페이지 이동
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: OngiColor.primary,
                    side:
                        const BorderSide(color: OngiColor.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                    style: OngiTextStyle.button18.copyWith(
                      color: OngiColor.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 아이디 찾기 | 비밀번호 변경
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: 아이디 찾기
                    },
                    child: Text(
                      '아이디 찾기',
                      style: OngiTextStyle.body15.copyWith(
                        color: OngiColor.systemGray03,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '|',
                      style: OngiTextStyle.body15.copyWith(
                        color: OngiColor.systemGray03,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: 비밀번호 변경
                    },
                    child: Text(
                      '비밀번호 변경',
                      style: OngiTextStyle.body15.copyWith(
                        color: OngiColor.systemGray03,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
