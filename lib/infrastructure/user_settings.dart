import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static const String _emailKey = 'user_email';
  static const String _codeKey = 'code';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getEmail() {
    return _prefs.getString(_emailKey);
  }

  Future<void> saveEmail(String email) async {
    await _prefs.setString(_emailKey, email);
  }

  Encoding get encoding {
    final code = _prefs.getString(_codeKey);
    if (code == null) return Encoding.unicode;
    return Encoding.values.firstWhere((e) => e.name == code);
  }

  Future<void> saveEncoding(Encoding code) async {
    await _prefs.setString(_codeKey, code.name);
  }
}

enum Encoding { unicode, menksoft }
