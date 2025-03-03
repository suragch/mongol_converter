import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:mongol_converter/infrastructure/converter.dart';
import 'package:mongol_converter/infrastructure/service_locator.dart';
import 'package:mongol_converter/infrastructure/word_repo.dart';
import 'package:pocketbase/pocketbase.dart';

class BrowserManager {
  final listNotifier = _WordListNotifier([]);
  final wordRepo = getIt<WordRepo>();
  final converter = getIt<Converter>();
  final pb = getIt<PocketBase>();
  void Function(bool, String)? _onResult;

  bool get isLoggedIn => pb.authStore.isValid;

  void init(void Function(bool, String) onWordAdded) {
    listNotifier.value = wordRepo.words.keys.toList();
    _onResult = onWordAdded;
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
    final message =
        success //
            ? 'амжилттай нэмэгдлээ'
            : 'алдаа гарлаа';
    _onResult?.call(success, message);
  }

  Future<void> updateWord(Word word) async {
    final success = await wordRepo.updateWord(word);
    if (success) {
      listNotifier.update();
    }
    final message =
        success //
            ? 'амжилттай хадгаллаа'
            : 'алдаа гарлаа';
    _onResult?.call(success, message);
  }

  Future<void> deleteWord(String cyrillic) async {
    final success = await wordRepo.deleteWord(cyrillic);
    if (success) {
      listNotifier.deleteItem(cyrillic);
    }
    final message =
        success //
            ? 'амжилттай устгалаа'
            : 'алдаа гарлаа';
    _onResult?.call(success, message);
  }

  void filterWords(String query) {
    if (query.isEmpty) {
      listNotifier.value = wordRepo.words.keys.toList();
    } else {
      listNotifier.value =
          wordRepo.words.keys.where((word) => word.startsWith(query)).toList();
    }
  }

  Future<void> saveToCSV() async {
    final csv = wordRepo.toCSV();
    final timestamp = DateTime.now().toIso8601String();
    await FileSaver.instance.saveFile(
      name: 'mongol_$timestamp',
      ext: 'csv',
      bytes: utf8.encode(csv),
      mimeType: MimeType.csv,
    );
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
