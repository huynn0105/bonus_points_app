import 'package:bonus_points_app/core/hive_database/hive_database.dart';
import 'package:get_it/get_it.dart';

import 'locator_dao.dart';
import 'locator_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => HiveDatabase());
  await locator<HiveDatabase>().init();
  registerServiceSingletons(locator);
  registerDaoSingletons(locator);

}
