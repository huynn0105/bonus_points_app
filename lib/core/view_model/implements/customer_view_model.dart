import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class CustomerViewModel with ChangeNotifier implements ICustomerViewModel {
  FirebaseFirestore store = FirebaseFirestore.instance;

  // .collection('customers');

  Types _selectType = Types.Thuong;

  Future<void> selectTypes(Types type) async {
    _selectType = type;
   await syncData();
    notifyListeners();
  }

  Future<void> syncData() async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    var data = await customers.get();

    List<CustomerEntity> customersInFirebase = data.docs
        .map((e) => CustomerEntity.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    _customersList.clear();

    for (var x in customersInFirebase) {
      var dataPointDetailFb =
          await customers.doc(x.id!).collection('point_detail').get();

      List<PointDetailEntity> pointsInFirebase = dataPointDetailFb.docs
          .map((element) => PointDetailEntity.fromJson(element.data()))
          .toList();

      _customersList.add(
        CustomerUIModel(
          customerId: x.id!,
          name: x.name,
          phoneNumber: x.phoneNumber,
          createTime: x.createTime,
          pointTotal: pointsInFirebase.fold(
            0,
            (previousValue, element) => previousValue + element.point,
          ),
          address: x.address,
        ),
      );
    }

    _customersList.sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    notifyListeners();
  }

  Future<void> putCustomerFirebase(CustomerEntity entity) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    await customers.doc(entity.id!).set(entity.toJson());
  }

  Future<void> updateCustomerFirebase(CustomerEntity entity) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    await customers.doc(entity.id!).update(entity.toJson());
  }

  Future<void> deleteCustomerFirebase(String id) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    await customers.doc(id).delete();
  }

  Future<void> putPointDetailFirebase(PointDetailEntity entity) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    await customers
        .doc(entity.customerId)
        .collection('point_detail')
        .doc(entity.id!)
        .set(entity.toJson());
  }

  Future<void> deletePointDetailFirebase(PointDetailEntity entity) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    await customers
        .doc(entity.customerId)
        .collection('point_detail')
        .doc(entity.id!)
        .delete();
  }

  List<CustomerUIModel> _customersList = [];
  @override
  Future<void> addCustomer(CustomerUIModel model) async {
    String id = Uuid().v4();
    final customer = CustomerEntity(
      id: id,
      name: model.name,
      phoneNumber: model.phoneNumber,
      address: model.address,
      pushSuccess: false,
    );
    //await customerService.insert(customer);
    final pointDetail = PointDetailEntity(
      point: model.pointTotal,
      customerId: id,
      comment: 'Thêm khách hàng',
      type: 1,
      pushSuccess: false,
    );
    await putCustomerFirebase(customer);
    await putPointDetailFirebase(pointDetail);

    notifyListeners();
  }

  Future<void> updateCustomer(CustomerUIModel model) async {
    final customerUpdate = CustomerEntity(
      id: model.customerId,
      name: model.name,
      phoneNumber: model.phoneNumber,
      address: model.address,
    );
    await updateCustomerFirebase(customerUpdate);
    notifyListeners();
  }

  @override
  List<CustomerUIModel> get customerUIs => _customersList;

  @override
  List<PointDetailEntity> get customerPointDetails => _pointDetail;
  List<PointDetailEntity> _pointDetail = [];

  Future<void> getCustomerPointDetails(String customerId) async {
    CollectionReference customers = store.collection(
        _selectType == Types.Thuong ? 'customerThuong' : 'customerSuaHop');

    var dataPointDetailFb =
        await customers.doc(customerId).collection('point_detail').get();

    _pointDetail = dataPointDetailFb.docs
        .map((element) => PointDetailEntity.fromJson(element.data()))
        .toList();

    _pointDetail.sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));
    notifyListeners();
  }

  @override
  Future<void> addPoint(
    String customerId,
    String comment,
    int point,
    int type,
  ) async {
    final pointEntity = PointDetailEntity(
      comment: comment,
      point: type == 1 ? point : -point,
      customerId: customerId,
      type: type,
      pushSuccess: false,
    );
    await putPointDetailFirebase(pointEntity);
    notifyListeners();
  }

  @override
  Future<void> deletePoint(PointDetailEntity entity) async {
    _pointDetail.remove(entity);

    await deletePointDetailFirebase(entity);
    notifyListeners();
  }

  @override
  Future<void> deleteCustomer(CustomerUIModel model) async {
    customerUIs.remove(model);
    await deleteCustomerFirebase(model.customerId!);
    notifyListeners();
  }

  @override
  Types get selectType => _selectType;
}
