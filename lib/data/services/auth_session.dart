class AuthSession {
  String? pendingLoginId;
  String? pendingPassword;
  String? loginSessionToken;

  void set(String loginId, String password) {
    pendingLoginId = loginId;
    pendingPassword = password;
  }

  void setLoginSessionToken(String token) {
    loginSessionToken = token;
  }

  void clear() {
    pendingLoginId = null;
    pendingPassword = null;
    loginSessionToken = null;
  }
}
