class AuthSession {
  String? pendingLoginId;
  String? pendingPassword;

  void set(String loginId, String password) {
    pendingLoginId = loginId;
    pendingPassword = password;
  }

  void clear() {
    pendingLoginId = null;
    pendingPassword = null;
  }
}
