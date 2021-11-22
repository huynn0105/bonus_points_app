import 'package:bonus_points_app/core/hive_database/daos/point_detail_dao.dart';
import 'package:bonus_points_app/core/hive_database/entities/point_detail/point_detail_entity.dart';
import 'package:bonus_points_app/core/services/interfaces/ipoint_detail_servier.dart';
import 'package:bonus_points_app/global/locator.dart';

class PointDetailService implements IPointDetailService {
  var _dao = locator<PointDetailDao>();
  @override
  List<PointDetailEntity> getPointDetailByCustomerId(String customerId) {
    return _dao.getAll().where((x) => x.customerId == customerId).toList();
  }

  @override
  Future<void> insert(PointDetailEntity entity) async {
    await _dao.insert(entity);
  }

  @override
  Future<void> delete(String id) async {
   await _dao.delete(id);
  }

  @override
  Future<void> clear()async{
   await _dao.clear();
  }

  @override
  Future<void> deleteAll(List<String> entities)async {
  await _dao.deleteAll(entities);
  }

  @override
  Future<void> insertAll(List<PointDetailEntity> entities) async{
   await _dao.insertAll(entities);
  }

  @override
  Future<void> updateAll(List<PointDetailEntity> entities) async{
   await _dao.updateAll(entities);
  }

  @override
  Future<void> update(PointDetailEntity entity) async{
   await _dao.update(entity);
  }
}
