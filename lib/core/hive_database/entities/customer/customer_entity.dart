import 'package:bonus_points_app/core/hive_database/entities/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerEntity extends BaseEntity {
  String name;
  String? phoneNumber;
  String? address;
  int totalPointThuong;
  int totalPointSuaLon;
  int tienNo;
  CustomerEntity({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.totalPointThuong = 0,
    this.totalPointSuaLon = 0,
    this.tienNo = 0,
  }) : super(id: id, createTime: createTime);


  CustomerEntity copyWith({
    String? id,
    DateTime? createTime,
    String? name,
    String? phoneNumber,
    String? address,
    int? totalPointThuong,
    int? totalPointSuaLon,
    int? tienNo,
  }){
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createTime: createTime ?? this.createTime,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tienNo: tienNo ?? this.tienNo,
      totalPointSuaLon: totalPointSuaLon ?? this.totalPointSuaLon,
      totalPointThuong: totalPointThuong ?? this.totalPointThuong,
    );
  }

  factory CustomerEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerEntityToJson(this);
}
