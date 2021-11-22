import 'package:bonus_points_app/core/hive_database/entities/base_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer_entity.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class CustomerEntity extends BaseEntity {
  @HiveField(1)
  String name;
  @HiveField(2)
  String? phoneNumber;
  @HiveField(3)
  String? address;
  @HiveField(4)
  bool pushSuccess;

  CustomerEntity({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.pushSuccess = true,
  }) : super(id: id, createTime: createTime);

  @override
  bool operator ==(Object other) {
    return other is CustomerEntity &&
        other.id == id &&
        other.createTime == createTime &&
        other.phoneNumber == phoneNumber &&
        other.name == name &&
        other.address == address;
  }

  bool isEqual(CustomerEntity entity) {
    return entity.id == id &&
        entity.createTime == createTime &&
        entity.phoneNumber == phoneNumber &&
        entity.name == name &&
        entity.address == address;
  }

  factory CustomerEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerEntityToJson(this);
}
