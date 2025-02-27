import 'package:flutter/widgets.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/user_settings.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../infrastructure/converter.dart';

class HomeManager {
  final addMongolNotifier = ValueNotifier<String>('');
  void Function(String)? onWordAdded;
  final wordRepo = getIt<WordRepo>();
  final pb = getIt<PocketBase>();
  String convertedText = '';
  List<String> unknownWords = [];
  final converter = getIt<Converter>();
  final userSettings = getIt<UserSettings>();

  String get storedUserEmail => userSettings.getEmail() ?? '';

  bool get isLoggedIn => pb.authStore.isValid;

  Future<void> loadWords() async {
    await wordRepo.fetchWords();
  }

  void convert(String text) {
    final (converted, words) = converter.convert(text);
    convertedText = converted;
    unknownWords = words;
  }

  String convertLatin(String latin) {
    return converter.latinToMenksoft(latin);
  }

  Future<void> login(String username, String password) async {
    await pb.collection('users').authWithPassword(username, password);
    userSettings.saveEmail(username);
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }

  Future<void> addWord({
    required String cyrillic,
    required String mongol,
  }) async {
    final success = await wordRepo.addWord(cyrillic, mongol);
    final message =
        success //
            ? '$cyrillic амжилттай нэмэгдлээ'
            : 'Үг нэмэхэд алдаа гарлаа';
    onWordAdded?.call(message);
  }
}
