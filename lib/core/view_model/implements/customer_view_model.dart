import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:bonus_points_app/core/services/interfaces/icustomer_service.dart';
import 'package:bonus_points_app/core/services/interfaces/ipoint_detail_servier.dart';
import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/locator.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class CustomerViewModel with ChangeNotifier implements ICustomerViewModel {
  ICustomerService customerService = locator<ICustomerService>();
  IPointDetailService pointDetailService = locator<IPointDetailService>();

  Future<void> syncData() async {
    var data = await Firestore.instance.collection("customers").get();
    List<CustomerEntity> customersInFirebase =
        data.map((element) => CustomerEntity.fromJson(element.map)).toList();

    List<String> customersIdInFb =
        customersInFirebase.map((e) => e.id!).toList();

    List<CustomerEntity> customersInDb = customerService.getAllCustomers();
    List<String> customersIdInDb = customersInDb.map((e) => e.id!).toList();

    List<CustomerEntity> customersToAdd = customersInFirebase
        .where((e) => !customersIdInDb.contains(e.id))
        .toList();
    List<CustomerEntity> customersToDelete =
        customersInDb.where((e) => !customersIdInFb.contains(e.id)).toList();
    List<CustomerEntity> customersToUpdate =
        customersInDb.where((e) => customersIdInFb.contains(e.id)).toList();

    if (customersToAdd.isNotEmpty) {
      await customerService.insertAll(customersToAdd);
    }
    if (customersToDelete.isNotEmpty) {
      await customerService
          .deleteAll(customersToDelete.map((e) => e.id!).toList());
    }
    if (customersToUpdate.isNotEmpty) {
      final List<CustomerEntity> customersToUpdated = [];
      for (var x in customersToUpdate) {
        final customerInDb =
            customersInDb.firstWhere((element) => element.id == x.id);
        final customerInFb =
            customersInFirebase.firstWhere((element) => element.id == x.id);
        if (!customerInDb.isEqual(customerInFb)) {
          customersToUpdated.add(customerInFb);
        }
      }
      if (customersToUpdated.isNotEmpty) {
        await customerService.updateAll(customersToUpdated);
      }
    }

    for (var x in customersInFirebase) {
      var dataPointDetailFb = await Firestore.instance
          .collection("customers")
          .document(x.id!)
          .collection('point_detail')
          .get();

      List<PointDetailEntity> pointsInFirebase = dataPointDetailFb
          .map((element) => PointDetailEntity.fromJson(element.map))
          .toList();

      List<String> pointIdsInFb = pointsInFirebase.map((e) => e.id!).toList();

      List<PointDetailEntity> pointsInDb =
          pointDetailService.getPointDetailByCustomerId(x.id!);

      List<String> pointIdsInDb = pointsInDb.map((e) => e.id!).toList();

      List<PointDetailEntity> pointsToAdd =
          pointsInFirebase.where((e) => !pointIdsInDb.contains(e.id)).toList();
      List<PointDetailEntity> pointsToDelete =
          pointsInDb.where((e) => !pointIdsInFb.contains(e.id)).toList();
      List<PointDetailEntity> pointsToUpdate =
          pointsInDb.where((e) => pointsInFirebase.contains(e.id)).toList();

      if (pointsToAdd.isNotEmpty) {
        await pointDetailService.insertAll(pointsToAdd);
      }
      if (pointsToDelete.isNotEmpty) {
        await pointDetailService
            .deleteAll(pointsToDelete.map((e) => e.id!).toList());
      }
      if (pointsToUpdate.isNotEmpty) {
        final List<PointDetailEntity> pointsToUpdated = [];
        for (var x in pointsToUpdate) {
          final pointInDb =
              pointsInDb.firstWhere((element) => element.id == x.id);
          final pointInFb =
              pointsInFirebase.firstWhere((element) => element.id == x.id);
          if (!pointInDb.isEqual(pointInFb)) {
            pointsToUpdated.add(pointInFb);
          }
        }
        if (pointsToUpdated.isNotEmpty) {
          await pointDetailService.updateAll(pointsToUpdated);
        }
      }
    }
  }

  Future<void> putCustomerFirebase(CustomerEntity entity) async {
    await Firestore.instance
        .collection("customers")
        .document(entity.id!)
        .create(entity.toJson());
  }

  Future<void> updateCustomerFirebase(CustomerEntity entity) async {
    await Firestore.instance
        .collection("customers")
        .document(entity.id!)
        .update(entity.toJson());
  }

  Future<void> deleteCustomerFirebase(String id) async {
    await Firestore.instance.collection("customers").document(id).delete();
  }

  Future<void> putPointDetailFirebase(PointDetailEntity entity) async {
    await Firestore.instance
        .collection("customers")
        .document(entity.customerId)
        .collection('point_detail')
        .document(entity.id!)
        .create(entity.toJson());
  }

  Future<void> deletePointDetailFirebase(PointDetailEntity entity) async {
    await Firestore.instance
        .collection("customers")
        .document(entity.customerId)
        .collection('point_detail')
        .document(entity.id!)
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
    await customerService.insert(customer);
    final pointDetail = PointDetailEntity(
      point: model.pointTotal,
      customerId: id,
      comment: 'Thêm khách hàng',
      type: 1,
      pushSuccess: false,
    );
    await pointDetailService.insert(pointDetail);
    notifyListeners();

    for (var x in customerService.getAllCustomers()) {
      if (!x.pushSuccess) {
        putCustomerFirebase(x).then((value) async {
          x.pushSuccess = true;
          await customerService.updateCustomer(x);
        });
      }

      for (var x in pointDetailService.getPointDetailByCustomerId(x.id!)) {
        if (!x.pushSuccess) {
          putPointDetailFirebase(x).then((value) async {
            x.pushSuccess = true;
            await pointDetailService.update(x);
          });
        }
      }
    }
  }

  Future<void> updateCustomer(CustomerUIModel model) async {
    final customerUpdate = CustomerEntity(
      id: model.customerId,
      name: model.name,
      phoneNumber: model.phoneNumber,
      address: model.address,
    );
    await customerService.updateCustomer(customerUpdate);
    notifyListeners();
    updateCustomerFirebase(customerUpdate);
  }

  @override
  List<CustomerUIModel> get customerUIs => _customersList;

  @override
  void getCustomers() {
    _customersList.clear();

    _customersList = customerService.getAllCustomers().map((e) {
      final pointDetails = pointDetailService.getPointDetailByCustomerId(e.id!);
      return CustomerUIModel(
        customerId: e.id!,
        name: e.name,
        phoneNumber: e.phoneNumber,
        createTime: e.createTime,
        pointTotal: pointDetails.fold(
          0,
          (previousValue, element) => previousValue + element.point,
        ),
        address: e.address,
      );
    }).toList();

    _customersList.sort((e1, e2) => e2.createTime!.compareTo(e1.createTime!));

    notifyListeners();
  }

  @override
  List<PointDetailEntity> get customerPointDetails => _pointDetail;
  List<PointDetailEntity> _pointDetail = [];

  void getCustomerPointDetails(String customerId) {
    _pointDetail = pointDetailService.getPointDetailByCustomerId(customerId);
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
    await pointDetailService.insert(pointEntity);
    notifyListeners();

    for (var x in pointDetailService.getPointDetailByCustomerId(customerId)) {
      if (!x.pushSuccess) {
        putPointDetailFirebase(x).then((value) async {
          x.pushSuccess = true;
          await pointDetailService.update(x);
        });
      }
    }
  }

  @override
  Future<void> deletePoint(PointDetailEntity entity) async {
    await pointDetailService.delete(entity.id!);
    _pointDetail.remove(entity);
    notifyListeners();
    deletePointDetailFirebase(entity);
  }

  @override
  Future<void> deleteCustomer(CustomerUIModel model) async {
    await customerService.delete(model.customerId!);
    customerUIs.remove(model);
    deleteCustomerFirebase(model.customerId!);
    notifyListeners();
  }
}
