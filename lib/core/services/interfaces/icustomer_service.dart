import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';

abstract class ICustomerService {
  Future<void> insert(CustomerEntity entity);
  Future<void> insertAll(List<CustomerEntity> entities);

  List<CustomerEntity> getAllCustomers();
  Future<void> deleteCustomer(CustomerEntity entity);
  Future<void> updateCustomer(CustomerEntity entity);
  Future<void> deleteAll(List<String> entity);
  Future<void> updateAll(List<CustomerEntity> entities);
  Future<void> delete(String id);
  Future<void> clear();
}
