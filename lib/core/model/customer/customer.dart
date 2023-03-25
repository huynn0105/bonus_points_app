import 'package:bonus_points_app/core/model/base_model.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends BaseModel {
  String name;
  String? phoneNumber;
  String? address;
  int point;
  int point1;
  int owe;
  Customer({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.point = 0,
    this.point1 = 0,
    this.owe = 0,
  }) : super(id: id, createTime: createTime);

  Map<String, dynamic> get values {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'point': point,
      'point1': point1,
      'owe': owe,
      'createTime': createTime,
      'customer': this,
    };
  }

  Customer copyWith({
    String? id,
    DateTime? createTime,
    String? name,
    String? phoneNumber,
    String? address,
    int? totalPointThuong,
    int? totalPointSuaLon,
    int? tienNo,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      createTime: createTime ?? this.createTime,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      owe: tienNo ?? this.owe,
      point1: totalPointSuaLon ?? this.point1,
      point: totalPointThuong ?? this.point,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
