import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/user_settings.dart';
import 'package:pocketbase/pocketbase.dart';

import '../infrastructure/converter.dart';

class HomeManager {
  String convertedText = '';
  List<String> unknownWords = [];
  final converter = Converter();
  final pb = PocketBase('http://127.0.0.1:8090/');
  final userSettings = getIt<UserSettings>();

  String get storedUserEmail => userSettings.getEmail() ?? '';

  bool get isLoggedIn => pb.authStore.isValid;

  void convert(String text) {
    final (converted, words) = converter.convert(text);
    convertedText = converted;
    unknownWords = words;
  }

  Future<void> login(String username, String password) async {
    await pb.collection('users').authWithPassword(username, password);
    userSettings.saveEmail(username);
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }
}
