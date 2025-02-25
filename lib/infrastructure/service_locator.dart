import 'package:get_it/get_it.dart';
import 'package:mongol_converter_db_creator/infrastructure/user_settings.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';
import 'package:pocketbase/pocketbase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
  getIt.registerLazySingleton<PocketBase>(
    () => PocketBase('http://127.0.0.1:8090/'),
  );
  getIt.registerLazySingleton<WordRepo>(() => WordRepo());
}
