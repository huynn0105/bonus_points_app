import 'package:bonus_points_app/core/services/implements/customer_service.dart';
import 'package:bonus_points_app/core/services/implements/point_detail_service.dart';
import 'package:bonus_points_app/core/services/interfaces/icustomer_service.dart';
import 'package:bonus_points_app/core/services/interfaces/ipoint_detail_servier.dart';
import 'package:get_it/get_it.dart';

void registerServiceSingletons(GetIt locator) {
  locator.registerLazySingleton<ICustomerService>(
    () => CustomerService(),
  );
  locator.registerLazySingleton<IPointDetailService>(
    () => PointDetailService(),
  );
}
