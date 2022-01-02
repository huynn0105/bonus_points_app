import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:flutter/cupertino.dart';

abstract class ICustomerViewModel with ChangeNotifier {
  Future<void> addCustomer(CustomerEntity model,int point,PointType pointType);
  CustomerEntity? currentCustomer;
  Future<void> updateCustomer(CustomerEntity model);

  Future<void> deletePoint(PointDetailEntity entity,PointType pointType);
  Future<void> deleteCustomer(CustomerEntity model);
  Future<void> syncData();
  Future<void> getCustomerPointDetails(String customerId);
  List<CustomerEntity> get customerUIs;
  List<PointDetailEntity> get customerPointDetailsThuong;
  List<PointDetailEntity> get customerPointDetailsSuaLon;
  List<PointDetailEntity> get customerPointDetailsGhiNo;
  List<CustomerEntity> get listSearchCustomer;

  List<CustomerEntity> get listCustomersNo;

  void searchCustomer(String searchText);
  Future<void> addPoint(
    CustomerEntity customer,
    String comment,
    int point,
    int type,
    PointType pointType
  );

  late bool isSearch;
  void getCustomerNo();
}
