import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';

abstract class IPointDetailService {
  Future<void> insert(PointDetailEntity entity);
  Future<void> insertAll(List<PointDetailEntity> entities);
  List<PointDetailEntity> getPointDetailByCustomerId(String customerId);
  Future<void> delete(String id);
  Future<void> updateAll(List<PointDetailEntity> entities);
  Future<void> update(PointDetailEntity entity);
  Future<void> clear();
  Future<void> deleteAll(List<String> entities);
}
