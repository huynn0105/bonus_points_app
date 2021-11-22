import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxName {
  static const String customers = 'customers'; //1
  static const String pointDetail = 'pointDetail'; //2

}

class HiveBoxMap {
  static Map<Type, MyHive> hiveBoxMap = {
    CustomerEntity: MyHive<CustomerEntity>(
      boxName: HiveBoxName.customers,
      registerAdapterFunction: () => Hive.registerAdapter(
        CustomerEntityAdapter(),
      ),
    ),
    PointDetailEntity: MyHive<PointDetailEntity>(
      boxName: HiveBoxName.pointDetail,
      registerAdapterFunction: () => Hive.registerAdapter(
        PointDetailEntityAdapter(),
      ),
    )
  };
}

class MyHive<EntityT> {
  String boxName;
  Future<void> Function()? openBoxFunction;
  void Function() registerAdapterFunction;

  MyHive({required this.boxName, required this.registerAdapterFunction}) {
    this.openBoxFunction = () async {
      await Hive.openBox<EntityT>(boxName);
    };
  }
}
