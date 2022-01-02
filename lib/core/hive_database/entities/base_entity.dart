import 'package:uuid/uuid.dart';

class BaseEntity  {
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
