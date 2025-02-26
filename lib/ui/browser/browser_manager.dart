import 'package:flutter/foundation.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

class BrowserManager {
  final listNotifier = _WordListNotifier([]);
  final wordRepo = getIt<WordRepo>();
  final converter = getIt<Converter>();

  void init() {
    listNotifier.value = wordRepo.words.keys.toList();
  }

  String wordAtIndex(int i) {
    return listNotifier.value[i];
  }

  String getMongol(String cyrillic) {
    return wordRepo.menksoftForCyrillic(cyrillic) ?? '';
  }

  String getLatin(String mongol) {
    return converter.menksoftToLatin(mongol);
  }

  Future<void> addWord(Word word) async {
    final success = await wordRepo.addWord(word.cyrillic, word.mongol);
    if (success) {
      listNotifier.addItem(word.cyrillic);
    }
  }

  Future<void> updateWord(Word word) async {
    final success = await wordRepo.updateWord(word);
    if (success) {
      listNotifier.update();
    }
  }

  Future<void> deleteWord(String cyrillic) async {
    final success = await wordRepo.deleteWord(cyrillic);
    if (success) {
      listNotifier.deleteItem(cyrillic);
    }
  }
}

class _WordListNotifier<T> extends ValueNotifier<List<String>> {
  _WordListNotifier(super.value);

  void addItem(String cyrillic) {
    value.add(cyrillic);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void deleteItem(String key) {
    value.remove(key);
    notifyListeners();
  }
}
