import 'package:bonus_points_app/core/hive_database/daos/customer_dao.dart';
import 'package:bonus_points_app/core/hive_database/daos/point_detail_dao.dart';
import 'package:get_it/get_it.dart';

void registerDaoSingletons(GetIt locator) {
  locator.registerLazySingleton(() => CustomerDao());
  locator.registerLazySingleton(() => PointDetailDao());
}
