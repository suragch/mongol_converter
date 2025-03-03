import 'package:flutter/widgets.dart';
import 'package:mongol_converter/infrastructure/converter.dart';
import 'package:mongol_converter/infrastructure/service_locator.dart';
import 'package:mongol_converter/infrastructure/user_settings.dart';
import 'package:mongol_converter/infrastructure/word_repo.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeManager {
  final addMongolNotifier = ValueNotifier<String>('');
  void Function(bool, String)? onWordAdded;
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

  Future<bool> login(String username, String password) async {
    try {
      await pb.collection('users').authWithPassword(username, password);
      userSettings.saveEmail(username);
      return true;
    } catch (e) {
      return false;
    }
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
            ? 'амжилттай нэмэгдлээ'
            : 'Үг нэмэхэд алдаа гарлаа';
    onWordAdded?.call(success, message);
  }

  String prepareTextToCopy() {
    final encoding = userSettings.encoding;
    switch (encoding) {
      case Encoding.menksoft:
        return convertedText;
      case Encoding.unicode:
        return converter.menksoftToUnicode(convertedText);
    }
  }
}
