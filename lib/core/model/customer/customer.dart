import 'package:bonus_points_app/core/model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends BaseModel {
  String name;
  String? phoneNumber;
  String? address;
  int totalPointThuong;
  int totalPointSuaLon;
  int tienNo;
  Customer({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.totalPointThuong = 0,
    this.totalPointSuaLon = 0,
    this.tienNo = 0,
  }) : super(id: id, createTime: createTime);


    Map<String, dynamic> get values {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'totalPointThuong': totalPointThuong,
      'totalPointSuaLon': totalPointSuaLon,
      'tienNo': tienNo,
      'createTime': createTime,
      'customer' : this,
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
  }){
    return Customer(
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

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerEntityToJson(this);
}
