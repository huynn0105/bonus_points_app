import 'package:bonus_points_app/core/model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_detail.g.dart';

@JsonSerializable(explicitToJson: true)

class PointDetail extends BaseModel {

  String customerId;
  int point;
  String comment;
  int type; //1 AccumulatePoints //2 Redeem
 

  PointDetail({
    String? id,
    DateTime? createTime,
    required this.customerId,
    required this.point,
    required this.comment,
    required this.type,
  }) : super(id: id, createTime: createTime);



  bool isEqual(PointDetail other) {
    return other.id == id &&
        other.createTime == createTime &&
        other.customerId == customerId &&
        other.comment == comment &&
        other.type == type &&
        other.point == point;
  }

  factory PointDetail.fromJson(Map<String, dynamic> json) =>
      _$PointDetailEntityFromJson(json);
  Map<String, dynamic> toJson() => _$PointDetailEntityToJson(this);
}
