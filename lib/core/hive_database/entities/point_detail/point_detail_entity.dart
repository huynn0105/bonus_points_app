import 'package:bonus_points_app/core/hive_database/entities/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_detail_entity.g.dart';

@JsonSerializable(explicitToJson: true)

class PointDetailEntity extends BaseEntity {

  String customerId;
  int point;
  String comment;
  int type; //1 AccumulatePoints //2 Redeem
 

  PointDetailEntity({
    String? id,
    DateTime? createTime,
    required this.customerId,
    required this.point,
    required this.comment,
    required this.type,
  }) : super(id: id, createTime: createTime);



  bool isEqual(PointDetailEntity other) {
    return other.id == id &&
        other.createTime == createTime &&
        other.customerId == customerId &&
        other.comment == comment &&
        other.type == type &&
        other.point == point;
  }

  factory PointDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$PointDetailEntityFromJson(json);
  Map<String, dynamic> toJson() => _$PointDetailEntityToJson(this);
}
