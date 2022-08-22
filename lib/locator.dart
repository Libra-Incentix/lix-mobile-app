import 'package:get_it/get_it.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => HelperService());
  locator.registerLazySingleton(() => APIServices());
  locator.registerLazySingleton(() => SnackBarService());
}
