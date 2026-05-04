import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/features/auth/login_screen.dart';
import 'package:ongi_app/features/auth/signup/phone_number_screen.dart';
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
      path: AppRoutes.signup,
      builder: (context, state) => const PhoneNumberScreen(),
    ),

    // 보호자 Shell (홈 / 일정 / 설정)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          GuardianShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianHome,
            builder: (context, state) =>
                const _PlaceholderScreen(label: '홈'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSchedule,
            builder: (context, state) =>
                const _PlaceholderScreen(label: '일정'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSettings,
            builder: (context, state) =>
                const _PlaceholderScreen(label: '설정'),
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
            builder: (context, state) =>
                const _PlaceholderScreen(label: '홈'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.elderSettings,
            builder: (context, state) =>
                const _PlaceholderScreen(label: '설정'),
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
