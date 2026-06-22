class LocalStorageService {
  static final List<Map<String, String>> _users = [];
  static String? _currentUser;

  static bool get isLoggedIn => _currentUser != null;
  static String? get currentUser => _currentUser;

  static bool register(String username, String password) {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }
    final exists = _users.any((u) => u['username'] == username);
    if (exists) {
      return false;
    }
    _users.add({'username': username, 'password': password});
    return true;
  }

  static bool login(String username, String password) {
    final user = _users.any(
      (u) => u['username'] == username && u['password'] == password,
    );
    if (user) {
      _currentUser = username;
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
  }
}
