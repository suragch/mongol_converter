import 'package:get_it/get_it.dart';
import 'package:mongol_converter/infrastructure/converter.dart';
import 'package:mongol_converter/infrastructure/user_settings.dart';
import 'package:mongol_converter/infrastructure/word_repo.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
  getIt.registerLazySingleton<PocketBase>(() => _getPocketBase());
  getIt.registerLazySingleton<WordRepo>(() => WordRepo());
  getIt.registerLazySingleton<Converter>(() => Converter());
}

PocketBase _getPocketBase() {
  if (kReleaseMode) {
    return PocketBase('https://cyrillic.suragch.dev/');
  } else {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PocketBase('http://10.0.2.2:8090/');
    }
    return PocketBase('http://127.0.0.1:8090/');
  }
}
