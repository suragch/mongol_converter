import 'package:get_it/get_it.dart';
import 'package:mongol_converter_db_creator/infrastructure/user_settings.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
  getIt.registerLazySingleton<WordRepo>(() => WordRepo());
}
