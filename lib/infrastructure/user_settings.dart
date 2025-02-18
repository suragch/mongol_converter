import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static const String _emailKey = 'user_email';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveEmail(String email) async {
    await _prefs.setString(_emailKey, email);
  }

  String? getEmail() {
    return _prefs.getString(_emailKey);
  }
}
