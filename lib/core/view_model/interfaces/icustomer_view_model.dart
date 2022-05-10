import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:flutter/cupertino.dart';

abstract class ICustomerViewModel with ChangeNotifier {
  Future<void> addCustomer(Customer model);
  Customer? currentCustomer;
  Future<void> updateCustomer(Customer model);
  Future<void> deletePoint(PointDetail entity);
  Future<void> deleteCustomer(Customer model);
  Future<void> syncData();
  Future<void> getCustomerPointDetails(String customerId);

  List<Customer> get customerUIs;
  List<PointDetail> get customerPointDetailsThuong;
  List<PointDetail> get customerPointDetailsSuaLon;
  List<PointDetail> get customerPointDetailsGhiNo;
  List<PointDetail> get customerPointDetails;
  List<Customer> get customersToDisplay;
  FilterType get filterType;
  void filterBy(FilterType filterType);
    void filterByDateRange(DateTime startDate, DateTime endDate);

  void searchCustomer(String searchText);
  Future<void> addPoint(Customer customer, String comment, int point, int point1,int owe);

  bool get searched;
  set searched(bool value);
}
