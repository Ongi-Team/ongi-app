abstract class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const signup = '/signup';
  static const signupAccountInfo = '/signup/account-info';
  static const signupElderlyInfo = '/signup/elderly-info';
  static const signupComplete = '/signup/complete';

  // 보호자
  static const guardianHome = '/guardian/home';
  static const guardianSchedule = '/guardian/schedule';
  static const guardianSettings = '/guardian/settings';

  // 어르신
  static const elderHome = '/elder/home';
  static const elderSettings = '/elder/settings';
}
