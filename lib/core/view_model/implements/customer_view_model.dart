import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

const point_detail_thuong = 'point_detail_thuong';
const point_detail_sua_lon = 'point_detail_sua_lon';
const point_detail_ghi_no = 'point_detail_ghi_no';

class CustomerViewModel with ChangeNotifier implements ICustomerViewModel {
  String checkPointType(PointType pointType) {
    switch (pointType) {
      case PointType.thuong:
        return point_detail_thuong;

      case PointType.lon:
        return point_detail_sua_lon;

      case PointType.no:
        return point_detail_ghi_no;
    }
  }

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  List<Customer> _listSearchCustomer = [];

  List<Customer> get listSearchCustomer => _listSearchCustomer;

  List<Customer> _allCustomers = [];

  Future<void> syncData() async {
    var data = await customers.limit(50).get();

    _customersList = data.docs
        .map((e) => Customer.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    _customersList.sort((e1, e2) => e1.createTime!.compareTo(e2.createTime!));

    notifyListeners();
    getAllCustomers();
  }

  Future<void> getAllCustomers() async {
    var allData = await customers.get();
    _allCustomers = allData.docs
        .map((e) => Customer.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  void searchCustomer(String searchText) {
    _listSearchCustomer.clear();
    _listSearchCustomer = _allCustomers
        .where((x) =>
            x.name.toLowerCase().contains(searchText.toLowerCase()) ||
            x.phoneNumber!.contains(searchText))
        .toList();

    isSearch = true;
  }

  Future<void> putCustomerFirebase(Customer entity) async {
    await customers.doc(entity.id!).set(entity.toJson());
  }

  Future<void> updateCustomerFirebase(Customer entity) async {
    await customers.doc(entity.id!).update(entity.toJson());
  }

  Future<void> deleteCustomerFirebase(String id) async {
    await customers.doc(id).delete();
  }

  Future<void> putPointDetailFirebase(
      PointDetail entity, PointType pointType) async {
    final path = checkPointType(pointType);
    await customers
        .doc(entity.customerId)
        .collection(path)
        .doc(entity.id!)
        .set(entity.toJson());
  }

  Future<void> deletePointDetailFirebase(
      PointDetail entity, PointType pointType) async {
    final path = checkPointType(pointType);
    await customers
        .doc(entity.customerId)
        .collection(path)
        .doc(entity.id!)
        .delete();
  }

  List<Customer> _customersList = [];
  @override
  Future<void> addCustomer(
      Customer model, int point, PointType pointType) async {
    final pointDetail = PointDetail(
      point: point,
      customerId: model.id!,
      comment: 'Thêm khách hàng',
      type: 1,
    );
    await putCustomerFirebase(model);
    _customersList.insert(0, model);
    _allCustomers.insert(0, model);
    _listSearchCustomer.insert(0, model);

    await putPointDetailFirebase(pointDetail, pointType);
    switch (pointType) {
      case PointType.thuong:
        _pointDetailThuong.add(pointDetail);
        break;

      case PointType.lon:
        _pointDetailSuaLon.add(pointDetail);
        break;

      case PointType.no:
        _pointDetailGhiNo.add(pointDetail);
        break;
    }

    notifyListeners();
  }

  Future<void> updateCustomer(Customer model) async {
    await updateCustomerFirebase(model);
    _customersList.removeWhere((x) => x.id == model.id);
    _customersList.insert(0, model);
    _allCustomers.removeWhere((x) => x.id == model.id);
    _allCustomers.insert(0, model);
    _listSearchCustomer.removeWhere((x) => x.id == model.id);
    _listSearchCustomer.insert(0, model);
    currentCustomer = model;
    isSearch = false;

    notifyListeners();
  }

  @override
  List<Customer> get customerUIs => _customersList;

  @override
  List<PointDetail> get customerPointDetailsThuong => _pointDetailThuong;
  List<PointDetail> _pointDetailThuong = [];

  Future<void> getCustomerPointDetails(String customerId) async {
    var dataPointDetailThuongFb =
        await customers.doc(customerId).collection(point_detail_thuong).get();

    _pointDetailThuong = dataPointDetailThuongFb.docs
        .map((element) => PointDetail.fromJson(element.data()))
        .toList();

    _pointDetailThuong
        .sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    var dataPointDetailSuaLonFb =
        await customers.doc(customerId).collection(point_detail_sua_lon).get();

    _pointDetailSuaLon = dataPointDetailSuaLonFb.docs
        .map((element) => PointDetail.fromJson(element.data()))
        .toList();

    _pointDetailSuaLon
        .sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    var dataPointDetailGhiNoFb =
        await customers.doc(customerId).collection(point_detail_ghi_no).get();

    _pointDetailGhiNo = dataPointDetailGhiNoFb.docs
        .map((element) => PointDetail.fromJson(element.data()))
        .toList();

    _pointDetailGhiNo
        .sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    notifyListeners();
  }

  @override
  Future<void> addPoint(
    Customer customer,
    String comment,
    int point,
    int type,
    PointType pointType,
  ) async {
    final pointEntity = PointDetail(
      comment: comment,
      point: type == 1 ? point : -point,
      customerId: customer.id!,
      type: type,
    );

    await putPointDetailFirebase(pointEntity, pointType);

    switch (pointType) {
      case PointType.thuong:
        _pointDetailThuong.insert(0, pointEntity);
        customer.totalPointThuong += type == 1 ? point : -point;
        break;

      case PointType.lon:
        _pointDetailSuaLon.insert(0, pointEntity);
        customer.totalPointSuaLon += type == 1 ? point : -point;
        break;

      case PointType.no:
        _pointDetailGhiNo.insert(0, pointEntity);
        customer.tienNo += type == 1 ? point : -point;
        break;
    }
    await updateCustomerFirebase(customer);
    _allCustomers.removeWhere((x) => x.id == customer.id!);
    _allCustomers.insert(0, customer);
    _listSearchCustomer.removeWhere((x) => x.id == customer.id!);
    _listSearchCustomer.insert(0, customer);

    notifyListeners();
  }

  @override
  Future<void> deletePoint(
      PointDetail entity, PointType pointType) async {
    await deletePointDetailFirebase(entity, pointType);

    var customer = _allCustomers.firstWhere((x) => x.id! == entity.customerId);

    switch (pointType) {
      case PointType.thuong:
        _pointDetailThuong.removeWhere((e) => e.id == entity.id);
        customer.totalPointThuong +=
            entity.type == 1 ? -entity.point : -entity.point;
        break;

      case PointType.lon:
        _pointDetailSuaLon.removeWhere((e) => e.id == entity.id);
        customer.totalPointSuaLon +=
            entity.type == 1 ? -entity.point : -entity.point;
        break;

      case PointType.no:
        _pointDetailGhiNo.removeWhere((e) => e.id == entity.id);
        customer.tienNo += entity.type == 1 ? -entity.point : -entity.point;
        break;
    }
    await updateCustomerFirebase(customer);
    _customersList.removeWhere((x) => x.id == entity.customerId);
    _customersList.insert(0,customer);
    _listSearchCustomer.removeWhere((x) => x.id == entity.customerId);
    _listSearchCustomer.insert(0,customer);

    notifyListeners();
  }

  @override
  Future<void> deleteCustomer(Customer model) async {
    await deleteCustomerFirebase(model.id!);

    _customersList.removeWhere((e) => e.id == model.id);
    _allCustomers.removeWhere((e) => e.id == model.id);
    _listSearchCustomer.removeWhere((e) => e.id == model.id);

    notifyListeners();
  }

  @override
  Customer? get currentCustomer => _currentCustomer;

  Customer? _currentCustomer;

  set currentCustomer(Customer? customer) {
    _currentCustomer = customer;
    notifyListeners();
  }

  List<PointDetail> _pointDetailSuaLon = [];

  List<PointDetail> _pointDetailGhiNo = [];

  @override
  List<PointDetail> get customerPointDetailsGhiNo => _pointDetailGhiNo;

  @override
  List<PointDetail> get customerPointDetailsSuaLon => _pointDetailSuaLon;

  bool _isSearch = false;

  bool get isSearch => _isSearch;

  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  List<PointDetail> _customerPointDetails = [];
  @override
  List<PointDetail> get customerPointDetails => _customerPointDetails;

}

enum PointType {
  thuong,
  lon,
  no,
}
