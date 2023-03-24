import 'package:uuid/uuid.dart';

class BaseModel  {
  String? id;
  DateTime? createTime;

  BaseModel({this.id, this.createTime}) {
    if (id == null) {
      id = Uuid().v4();
    }
    if (createTime == null) {
      createTime = DateTime.now();
    }
  }
}
