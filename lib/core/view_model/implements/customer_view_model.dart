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
  CollectionReference customerRef = FirebaseFirestore.instance.collection('customers_v3');
  final firstDayOfYear = DateTime(2024, 2, 10, 0, 0, 0);
  final lastDayOfYear = DateTime(2025, 1, 28, 23, 59, 59);
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
  int _totalPointOfYear = 0;

  @override
  int get totalPointOfYear => _totalPointOfYear;

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
    // await _copyData();
    await _getAllCustomers();
    _customersUI.addAll(_allCustomers.take(100));

    notifyListeners();

    // await _copyData();
  }

  Future<void> _copyData() async {
    await _getAllCustomers();
    print('start update data, sum ${_allCustomers.length} record');


    for (int i = 0; i < _allCustomers.length; i++) {
      final customer = _allCustomers[i];

      final dataPointDetailFb = await customerRef.doc(customer.id).collection('point_detail').get();
      final customerPointDetails = dataPointDetailFb.docs.map((e) => PointDetail.fromJson(e.data())).toList();

      final pointDetailsOfYear = customerPointDetails
          .where((x) =>
              x.type == 0 &&
              x.value > 0 &&
              firstDayOfYear.isBefore(x.createTime!) &&
              lastDayOfYear.isAfter(x.createTime!))
          .toList();

      final totalPointOfYear = pointDetailsOfYear.fold<int>(0, (prev, e) => prev + e.value);
      final customerUpdate = customer.copyWith(bestByYear2024: totalPointOfYear);

      final total = _customerPointDetails
          .where((x) =>
              firstDayOfYear.isBefore(x.createTime!) &&
              lastDayOfYear.isAfter(x.createTime!) &&
              x.type == 0 &&
              x.value > 0)
          .fold<int>(0, (prev, next) => prev + next.value);

      try {
        await customerRef.doc(customerUpdate.id!).update(customerUpdate.toJson());

        print('successful $i name ${customer.name}: total: $totalPointOfYear ---- $total');
      } catch (e) {
        print('fail $i name ${customer.name}');
      }
    }
    print('update data successful + ${_allCustomers.length}');

    // for (int i = 0; i < _allCustomers.length; i++) {
    //   for (int i = 0; i < _allCustomers.length; i++) {
    //     var customer = _allCustomers[i];
    //     String customerId = customer.id.toString();
    //     var dataPointDetailFb =
    //         await customerRef.doc(customerId).collection('point_detail').get();

    //     _customerPointDetails = dataPointDetailFb.docs
    //         .map((e) => PointDetail.fromJson(e.data()))
    //         .toList();
    //     final listInYear = _customerPointDetails
    //         .where((element) =>
    //             element.type == 0 &&
    //             element.value > 0 &&
    //             (element.createTime!.compareTo(firstDayOfYear) >= 0))
    //         .toList();

    //     int bestByYear = listInYear.fold(0, (prev, e) => prev + e.value);
    //     customer.bestByYear = bestByYear;

    //     // await customers3.doc(customerId).set(customer.toJson());
    //     // for (var pointDetail in _customerPointDetails) {
    //     //     await customers3
    //     //     .doc(pointDetail.customerId)
    //     //     .collection(path)
    //     //     .doc(pointDetail.id!)

    //     //     .set(pointDetail.toJson());
    //     // }
    //     print('successful $i name ${customer.name}');
    //  }
    //   print('copy data successful + ${_allCustomers.length}');
    // }
  }

  Future<void> _getAllCustomers() async {
    var allData = await customerRef.get();

    for (var customerDto in allData.docs) {
      try {
        var customer = Customer.fromJson(customerDto.data() as Map<String, dynamic>);
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
              x.name.toLowerCase().contains(searchText.toLowerCase()) || x.phoneNumber!.contains(searchText))
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
      await customerRef.doc(entity.id!).set(entity.toJson());
    } catch (e) {}
  }

  Future<void> _updateCustomerFirebase(Customer entity) async {
    try {
      await customerRef.doc(entity.id!).update(entity.copyWith(createTime: DateTime.now()).toJson());
    } catch (e) {}
  }

  Future<void> _deleteCustomerFirebase(String id) async {
    try {
      await customerRef.doc(id).delete();
    } catch (e) {}
  }

  Future<void> _putPointDetailFirebase(PointDetail entity) async {
    try {
      await customerRef.doc(entity.customerId).collection(path).doc(entity.id!).set(entity.toJson());
    } catch (e) {}
  }

  Future<void> _deletePointDetailFirebase(PointDetail entity) async {
    await customerRef.doc(entity.customerId).collection(path).doc(entity.id!).delete();
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    var pointDetail = PointDetail(
      value: 0,
      customerId: customer.id!,
      comment: 'Thêm mới',
      type: 0,
    );

    if (customer.point != 0) {
      pointDetail = pointDetail.copyWith(value: customer.point, type: 0);
      if (lastDayOfYear.isAfter(pointDetail.createTime!)) {
        customer = customer.copyWith(bestByYear2024: customer.point);
      }
    }
    if (customer.pointLon != 0) {
      pointDetail = pointDetail.copyWith(value: customer.pointLon, type: 3);
    }

    if (customer.owe != 0) {
      pointDetail = pointDetail.copyWith(value: customer.owe, type: 2);
    }
    _addCustomerToList(customer);
    await _putCustomerFirebase(customer);
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
    _removeCustomerList(customer);
    _addCustomerToList(customer);
    currentCustomer = customer;
    searched = false;
    notifyListeners();
    await _updateCustomerFirebase(customer);
  }

  void _removeCustomerList(Customer customer) {
    _customersUI.removeWhere((x) => x.id == customer.id);
    _allCustomers.removeWhere((x) => x.id == customer.id);
    _customersToDisplay.removeWhere((x) => x.id == customer.id);
  }

  Future<void> getCustomerPointDetails(String customerId) async {
    var dataPointDetailFb = await customerRef.doc(customerId).collection('point_detail').get();
    print('customerId: $customerId');

    _customerPointDetails = dataPointDetailFb.docs.map((e) => PointDetail.fromJson(e.data())).toList();
    _customerPointDetails.sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    // final total = _customerPointDetails
    //     .where((x) => x.createTime?.year == 2023 && x.type == 0 && x.value > 0)
    //     .fold<int>(0, (prev, next) => prev + next.value);

    // _totalPointOfYear = total;

    notifyListeners();
  }

  @override
  Future<void> addPoint(Customer customer, String comment, int point, int point1, int owe) async {
    var pointEntity = PointDetail(
      comment: comment,
      value: 0,
      customerId: customer.id!,
      type: 0,
    );
    if (point != 0) {
      pointEntity = pointEntity.copyWith(value: point, type: 0);
      customer.point += point;
      if (point > 0 && lastDayOfYear.isAfter(pointEntity.createTime!)) {
        customer.bestByYear2024 += point;
      }
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }
    if (point1 != 0) {
      customer.pointLon += point1;
      pointEntity = pointEntity.copyWith(value: point1, type: 3);
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }

    if (owe != 0) {
      customer.owe += owe;
      pointEntity = pointEntity.copyWith(value: owe, type: 2);
      await _updateCustomerAndPointDetail(pointEntity, customer);
    }

    notifyListeners();
  }

  Future<void> _updateCustomerAndPointDetail(PointDetail pointEntity, Customer customer) async {
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
        if (lastDayOfYear.isAfter(entity.createTime!)) {
          customer.bestByYear2024 -= entity.value;
        }
        break;

      case 3:
        customer.pointLon -= entity.value;
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
        _allCustomers.sort((b, a) => a.pointLon.compareTo(b.pointLon));

        break;
      case FilterType.owe:
        _allCustomers.sort((b, a) => a.owe.compareTo(b.owe));

        break;
      case FilterType.crateTime:
        _allCustomers.sort((b, a) => a.createTime!.compareTo(b.createTime!));

        break;
      case FilterType.buybest:
        _allCustomers.sort((b, a) => a.bestByYear2024.compareTo(b.bestByYear2024));
        notifyListeners();
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
            x.createTime!.millisecondsSinceEpoch >= startDate.millisecondsSinceEpoch &&
            x.createTime!.millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch)
        .toList()
        .take(100)
        .toList();
    _customersUI.clear();
    _customersUI.addAll(customers);
    notifyListeners();
  }

  @override
  Future<void> changeWithdraw(
    bool isWithdraw,
    Customer customer, {
    bool isSort = false,
  }) async {
    customer.isLunarGift = isWithdraw;
    final customerUpdate = customer.copyWith(isLunarGift: isWithdraw);

    if (isSort) {
      await updateCustomer(customerUpdate);
    } else {
      currentCustomer = customer;
      searched = false;
      notifyListeners();
      await _updateCustomerFirebase(customer);
    }
  }

  @override
  Future<void> changeGift(
    bool isGifted,
    Customer customer, {
    bool isSort = false,
  }) async {
    customer.isLunarGift = isGifted;
    final customerUpdate = customer.copyWith(isLunarGift: isGifted);

    if (isSort) {
      await updateCustomer(customerUpdate);
    } else {
      currentCustomer = customer;
      notifyListeners();
      await _updateCustomerFirebase(customer);
    }
  }
}

enum PointType {
  thuong,
  lon,
  no,
}
