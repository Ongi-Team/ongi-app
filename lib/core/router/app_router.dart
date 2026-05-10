import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/features/auth/login/login_screen.dart';
import 'package:ongi_app/features/auth/role_select/role_select_screen.dart';
import 'package:ongi_app/features/auth/signup/account_info_screen.dart';
import 'package:ongi_app/features/auth/signup/elderly_info_screen.dart';
import 'package:ongi_app/features/auth/signup/signup_complete_screen.dart';
import 'package:ongi_app/features/auth/signup/phone_number_screen.dart';
import 'package:ongi_app/features/auth/signup/signup_view_model.dart';
import 'package:ongi_app/features/elder/elder_shell.dart';
import 'package:ongi_app/features/guardian/guardian_shell.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelect,
      builder: (context, state) => const RoleSelectScreen(),
    ),

    // 회원가입 플로우 - SignupViewModel을 두 화면이 공유
    ShellRoute(
      builder: (context, state, child) => ChangeNotifierProvider(
        create: (_) => SignupViewModel(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const PhoneNumberScreen(),
        ),
        GoRoute(
          path: AppRoutes.signupAccountInfo,
          builder: (context, state) => const AccountInfoScreen(),
        ),
        GoRoute(
          path: AppRoutes.signupElderlyInfo,
          builder: (context, state) => const ElderlyInfoScreen(),
        ),
        GoRoute(
          path: AppRoutes.signupComplete,
          builder: (context, state) => const SignupCompleteScreen(),
        ),
      ],
    ),

    // 보호자 Shell (홈 / 일정 / 설정)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          GuardianShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianHome,
            builder: (context, state) => const _PlaceholderScreen(label: '홈'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSchedule,
            builder: (context, state) => const _PlaceholderScreen(label: '일정'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSettings,
            builder: (context, state) => const _PlaceholderScreen(label: '설정'),
          ),
        ]),
      ],
    ),

    // 어르신 Shell (홈 / 설정)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ElderShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.elderHome,
            builder: (context, state) => const _PlaceholderScreen(label: '홈'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.elderSettings,
            builder: (context, state) => const _PlaceholderScreen(label: '설정'),
          ),
        ]),
      ],
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}
