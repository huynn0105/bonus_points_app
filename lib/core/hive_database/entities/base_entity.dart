import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class BaseEntity extends HiveObject {
  @HiveField(0)
  String? id;
  DateTime? createTime;

  BaseEntity({this.id, this.createTime}) {
    if (id == null) {
      id = Uuid().v4();
    }
    if (createTime == null) {
      createTime = DateTime.now();
    }
  }
}
