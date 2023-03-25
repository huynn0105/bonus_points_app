import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

const point_detail_thuong = 'point_detail_thuong';
const point_detail_sua_lon = 'point_detail_sua_lon';
const point_detail_ghi_no = 'point_detail_ghi_no';
const path = 'point_detail';

class CustomerViewModel with ChangeNotifier implements ICustomerViewModel {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  List<Customer> _customersToDisplay = [];
  List<Customer> _customersUI = [];
  List<PointDetail> _pointDetailThuong = [];
  List<Customer> _allCustomers = [];
  List<PointDetail> _pointDetailSuaLon = [];
  List<PointDetail> _pointDetailGhiNo = [];
  List<PointDetail> _customerPointDetails = [];
  FilterType _filterType = FilterType.none;
  bool _searched = false;
  Customer? _currentCustomer;

  @override
  Customer? get currentCustomer => _currentCustomer;

  @override
  set currentCustomer(Customer? customer) {
    _currentCustomer = customer;
    notifyListeners();
  }

  @override
  List<PointDetail> get customerPointDetailsGhiNo => _pointDetailGhiNo;

  @override
  List<PointDetail> get customerPointDetailsSuaLon => _pointDetailSuaLon;

  @override
  bool get searched => _searched;

  @override
  set searched(bool value) {
    _searched = value;
    notifyListeners();
  }

  @override
  List<Customer> get customerUIs => _customersUI;

  @override
  List<PointDetail> get customerPointDetailsThuong => _pointDetailThuong;

  @override
  List<PointDetail> get customerPointDetails => _customerPointDetails;

  @override
  List<Customer> get customersToDisplay => _customersToDisplay;

  @override
  Future<void> syncData() async {
    _filterType = FilterType.none;

    _customersUI.clear();
    await _getAllCustomers();
    _customersUI.addAll(_allCustomers.take(100));
    notifyListeners();

    // await _copyData();
  }

  Future<void> _copyData() async {
    await _getAllCustomers();
    print('start copy data, sum ${_allCustomers.length} record');
    final lastYear = DateTime(2022, 1, 1, 1);
    for (int i = 0; i < _allCustomers.length; i++) {
      var customer = _allCustomers[i];
      String customerId = customer.id.toString();
      var dataPointDetailFb =
          await customers.doc(customerId).collection('point_detail').get();

      _customerPointDetails = dataPointDetailFb.docs
          .map((e) => PointDetail.fromJson(e.data()))
          .toList();
      // final listInYear = _customerPointDetails
      //     .where((element) =>
      //         element.type == 0 &&
      //         element.value > 0 &&
      //         (element.createTime!.compareTo(lastYear) >= 0))
      //     .toList();

      // int bestByYear = listInYear.fold(0, (prev, e) => prev + e.value);
      // customer.bestByYear = bestByYear;
      // await customers3.doc(customerId).set(customer.toJson());
      // for (var pointDetail in _customerPointDetails) {
      //     await customers3
      //     .doc(pointDetail.customerId)
      //     .collection(path)
      //     .doc(pointDetail.id!)

      //     .set(pointDetail.toJson());
      // }
      print('successful $i name ${customer.name}');
    }
    print('copy data successful + ${_allCustomers.length}');
  }

  Future<void> _getAllCustomers() async {
    var allData = await customers.get();

    for (var customerDto in allData.docs) {
      try {
        var customer =
            Customer.fromJson(customerDto.data() as Map<String, dynamic>);
        _allCustomers.add(customer);
      } catch (e) {
        print(customerDto);
      }
    }
  }

  void searchCustomer(String searchText) {
    if (searchText != '') {
      _customersToDisplay.clear();
      _customersToDisplay = _allCustomers
          .where((x) =>
              x.name.toLowerCase().contains(searchText.toLowerCase()) ||
              x.phoneNumber!.contains(searchText))
          .toList();

      _searched = true;
    } else {
      _customersUI.clear();
      _customersUI.addAll(_allCustomers.take(100).toList());
    }
    _filterType = FilterType.none;
    notifyListeners();
  }

  Future<void> _putCustomerFirebase(Customer entity) async {
    try {
      await customers.doc(entity.id!).set(entity.toJson());
    } catch (e) {}
  }

  Future<void> _updateCustomerFirebase(Customer entity) async {
    try {
      await customers
          .doc(entity.id!)
          .update(entity.copyWith(createTime: DateTime.now()).toJson());
    } catch (e) {}
  }

  Future<void> _deleteCustomerFirebase(String id) async {
    try {
      await customers.doc(id).delete();
    } catch (e) {}
  }

  Future<void> _putPointDetailFirebase(PointDetail entity) async {
    try {
      await customers
          .doc(entity.customerId)
          .collection(path)
          .doc(entity.id!)
          .set(entity.toJson());
    } catch (e) {}
  }

  Future<void> _deletePointDetailFirebase(PointDetail entity) async {
    await customers
        .doc(entity.customerId)
        .collection(path)
        .doc(entity.id!)
        .delete();
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    _addCustomerToList(customer);
    _putCustomerFirebase(customer);
    var pointDetail = PointDetail(
      value: 0,
      customerId: customer.id!,
      comment: 'Thêm mới',
      type: 0,
    );

    if (customer.point != 0) {
      pointDetail = pointDetail.copyWith(value: customer.point, type: 0);
    }
    if (customer.point1 != 0) {
      pointDetail = pointDetail.copyWith(value: customer.point1, type: 1);
    }

    if (customer.owe != 0) {
      pointDetail = pointDetail.copyWith(value: customer.owe, type: 2);
    }
    //customer.listPoint.add(pointDetail);
    await _putPointDetailFirebase(pointDetail);

    notifyListeners();
  }

  void _addCustomerToList(Customer customer) {
    _customersUI.insert(0, customer);
    _allCustomers.insert(0, customer);
    _customersToDisplay.insert(0, customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    await _updateCustomerFirebase(customer);
    _removeCustomerList(customer);
    _addCustomerToList(customer);

    currentCustomer = customer;
    searched = false;

    notifyListeners();
  }

  void _removeCustomerList(Customer customer) {
    _customersUI.removeWhere((x) => x.id == customer.id);
    _allCustomers.removeWhere((x) => x.id == customer.id);
    _customersToDisplay.removeWhere((x) => x.id == customer.id);
  }

  Future<void> getCustomerPointDetails(String customerId) async {
    var dataPointDetailFb =
        await customers.doc(customerId).collection('point_detail').get();

    _customerPointDetails = dataPointDetailFb.docs
        .map((e) => PointDetail.fromJson(e.data()))
        .toList();
    _customerPointDetails
        .sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));
    notifyListeners();
  }

  @override
  Future<void> addPoint(
      Customer customer, String comment, int point, int point1, int owe) async {
    var pointEntity = PointDetail(
      comment: comment,
      value: 0,
      customerId: customer.id!,
      type: 0,
    );
    if (point != 0) {
      pointEntity = pointEntity.copyWith(value: point, type: 0);
      customer.point += point;
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }
    if (point1 != 0) {
      customer.point1 += point1;
      pointEntity = pointEntity.copyWith(value: point1, type: 1);
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }

    if (owe != 0) {
      customer.owe += owe;
      pointEntity = pointEntity.copyWith(value: owe, type: 2);
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }

    notifyListeners();
  }

  Future<void> _updateCustomerAndPointDetail(
      PointDetail pointEntity, Customer customer) async {
    _customerPointDetails.insert(0, pointEntity);
    await _updateCustomerFirebase(customer);
    await _putPointDetailFirebase(pointEntity);
    _removeCustomerList(customer);
    _addCustomerToList(customer);
  }

  @override
  Future<void> deletePoint(PointDetail entity) async {
    await _deletePointDetailFirebase(entity);

    var customer = _allCustomers.firstWhere((x) => x.id! == entity.customerId);
    _customerPointDetails.removeWhere((e) => e.id == entity.id);
    switch (entity.type) {
      case 0:
        customer.point -= entity.value;
        break;

      case 1:
        customer.point1 -= entity.value;
        break;

      case 2:
        customer.owe -= entity.value;
        break;
    }
    await _updateCustomerFirebase(customer);
    _removeCustomerList(customer);
    _addCustomerToList(customer);

    notifyListeners();
  }

  @override
  Future<void> deleteCustomer(Customer customer) async {
    await _deleteCustomerFirebase(customer.id!);

    _removeCustomerList(customer);

    notifyListeners();
  }

  @override
  void filterBy(FilterType filterType) {
    _searched = false;
    _filterType = filterType;
    _customersUI.clear();
    switch (filterType) {
      case FilterType.point:
        _allCustomers.sort((b, a) => a.point.compareTo(b.point));
        break;

      case FilterType.point1:
        _allCustomers.sort((b, a) => a.point1.compareTo(b.point1));
        break;

      case FilterType.owe:
        _allCustomers.sort((b, a) => a.owe.compareTo(b.owe));
        break;

      case FilterType.crateTime:
        _allCustomers.sort((b, a) => a.createTime!.compareTo(b.createTime!));
        break;

      default:
        _allCustomers.sort((b, a) => a.point.compareTo(b.point));
        break;
    }
    _customersUI.addAll(_allCustomers.take(100).toList());
    notifyListeners();
  }

  @override
  FilterType get filterType => _filterType;

  @override
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    _searched = false;
    _filterType = filterType;
    final customers = _allCustomers
        .where((x) =>
            x.createTime!.millisecondsSinceEpoch >=
                startDate.millisecondsSinceEpoch &&
            x.createTime!.millisecondsSinceEpoch <=
                endDate.millisecondsSinceEpoch)
        .toList()
        .take(100)
        .toList();
    _customersUI.clear();
    _customersUI.addAll(customers);
    notifyListeners();
  }
}

enum PointType {
  thuong,
  lon,
  no,
}
