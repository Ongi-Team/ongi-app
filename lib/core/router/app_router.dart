import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/core/router/auth_redirect_notifier.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/features/auth/login/login_screen.dart';
import 'package:ongi_app/features/auth/role_select/role_select_screen.dart';
import 'package:ongi_app/features/auth/signup/account_info_screen.dart';
import 'package:ongi_app/features/auth/signup/elderly_info_screen.dart';
import 'package:ongi_app/features/auth/signup/signup_complete_screen.dart';
import 'package:ongi_app/features/auth/signup/phone_number_screen.dart';
import 'package:ongi_app/features/auth/signup/signup_view_model.dart';
import 'package:ongi_app/features/elder/elder_shell.dart';
import 'package:ongi_app/features/elder/home/elder_home_screen.dart';
import 'package:ongi_app/features/elder/setting/elder_setting_screen.dart';
import 'package:ongi_app/features/guardian/guardian_shell.dart';
import 'package:ongi_app/features/guardian/home/guardian_home_screen.dart';
import 'package:ongi_app/features/guardian/schedule/schedule_screen.dart';
import 'package:ongi_app/features/guardian/setting/device/device_connect_screen.dart';
import 'package:ongi_app/features/guardian/setting/guardian_setting_screen.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  refreshListenable: AuthRedirectNotifier.signal,
  redirect: (context, state) async {
    final storage = getIt<SecureStorageRepository>();
    final accessToken = await storage.readAccessToken();
    final refreshToken = await storage.readRefreshToken();
    final role = await storage.readRole();
    final location = state.uri.path;
    final homeRoute = _homeRouteForRole(role);

    final isLoggedIn = accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty &&
        role != null &&
        role.isNotEmpty &&
        homeRoute != null;

    final isAuthRoute = _authRoutes.contains(location);
    final isSignupRoute = _signupRoutes.contains(location);

    if (!isLoggedIn) {
      if (isAuthRoute || isSignupRoute) return null;
      return AppRoutes.login;
    }

    if (isAuthRoute || isSignupRoute) {
      return homeRoute;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelect,
      builder: (context, state) => const RoleSelectScreen(),
    ),
    GoRoute(
      path: AppRoutes.guardianDeviceQrScan,
      builder: (context, state) => const DeviceQrScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.guardianDeviceWifi,
      builder: (context, state) => DeviceWifiInputScreen(
        deviceCode: state.uri.queryParameters['deviceCode'],
      ),
    ),
    GoRoute(
      path: AppRoutes.guardianDeviceSuccess,
      builder: (context, state) => const DeviceConnectSuccessScreen(),
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
            builder: (context, state) => const GuardianHomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSchedule,
            builder: (context, state) => const GuardianScheduleScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.guardianSettings,
            builder: (context, state) => const GuardianSettingScreen(),
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
            builder: (context, state) => const ElderHomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.elderSettings,
            builder: (context, state) => const ElderSettingScreen(),
          ),
        ]),
      ],
    ),
  ],
);

const Set<String> _authRoutes = {
  AppRoutes.login,
  AppRoutes.roleSelect,
};

const Set<String> _signupRoutes = {
  AppRoutes.signup,
  AppRoutes.signupAccountInfo,
  AppRoutes.signupElderlyInfo,
  AppRoutes.signupComplete,
};

String? _homeRouteForRole(String? role) {
  switch (role) {
    case 'GUARDIAN':
      return AppRoutes.guardianHome;
    case 'ELDER':
      return AppRoutes.elderHome;
    default:
      return null;
  }
}
