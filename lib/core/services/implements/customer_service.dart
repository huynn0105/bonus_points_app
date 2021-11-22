import 'package:bonus_points_app/core/hive_database/daos/customer_dao.dart';
import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/services/interfaces/icustomer_service.dart';
import 'package:bonus_points_app/global/locator.dart';

class CustomerService implements ICustomerService {
  var _dao = locator<CustomerDao>();

  @override
  Future<void> deleteCustomer(CustomerEntity entity) async {
    await _dao.delete(entity.id!);
  }

  @override
  List<CustomerEntity> getAllCustomers() {
    return _dao.getAll();
  }

  @override
  Future<void> insert(CustomerEntity entity) async {
    await _dao.insert(entity);
  }

  @override
  Future<void> updateCustomer(CustomerEntity entity) async {
    await _dao.update(entity);
  }

  @override
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  @override
  Future<void> clear() async {
    await _dao.clear();
  }

  @override
  Future<void> insertAll(List<CustomerEntity> entities) async {
    await _dao.insertAll(entities);
  }

  @override
  Future<void> deleteAll(List<String> entities) async{
   await _dao.deleteAll(entities);
  }

  @override
  Future<void> updateAll(List<CustomerEntity> entities) async{
   await _dao.updateAll(entities);
  }
}
