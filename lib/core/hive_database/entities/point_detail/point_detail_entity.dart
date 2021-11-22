import 'package:bonus_points_app/core/hive_database/entities/base_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_detail_entity.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class PointDetailEntity extends BaseEntity {
  @HiveField(1)
  String customerId;
  @HiveField(2)
  int point;
  @HiveField(3)
  String comment;
  @HiveField(4)
  int type; //1 AccumulatePoints //2 Redeem
  @HiveField(5)
  bool pushSuccess;

  PointDetailEntity({
    String? id,
    DateTime? createTime,
    required this.customerId,
    required this.point,
    required this.comment,
    required this.type,
    this.pushSuccess = true,
  }) : super(id: id, createTime: createTime);

  @override
  bool operator ==(Object other) {
    return other is PointDetailEntity &&
        other.id == id &&
        other.createTime == createTime &&
        other.customerId == customerId &&
        other.comment == comment &&
        other.type == type &&
        other.point == point;
  }

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
