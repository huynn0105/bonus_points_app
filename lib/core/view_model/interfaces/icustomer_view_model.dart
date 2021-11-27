import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:flutter/cupertino.dart';

abstract class ICustomerViewModel with ChangeNotifier {
  Future<void> addCustomer(CustomerUIModel model);
  Future<void> updateCustomer(CustomerUIModel model);
  Future<void> selectTypes(Types type);
  Types get selectType;
  Future<void> deletePoint(PointDetailEntity entity);
  Future<void> deleteCustomer(CustomerUIModel model);
  Future<void> syncData();
  void getCustomerPointDetails(String customerId);
  List<CustomerUIModel> get customerUIs;
  List<PointDetailEntity> get customerPointDetails;
  Future<void> addPoint(
    String customerId,
    String comment,
    int point,
    int type,
  );
}
