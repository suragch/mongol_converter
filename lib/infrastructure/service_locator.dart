import 'package:get_it/get_it.dart';
import 'package:mongol_converter_db_creator/infrastructure/user_settings.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
}
