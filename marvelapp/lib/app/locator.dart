import 'package:get_it/get_it.dart';
import 'package:marvelapp/service/repository_manager.dart';

var locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => RepositoryManager());
}
