import 'package:bonus_points_app/core/model/base_model.dart';
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
  int bestByYear;
  bool isWithdraw;
  bool isGifted;


  Customer({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.point = 0,
    this.point1 = 0,
    this.owe = 0,
    this.bestByYear = 0,
    this.isWithdraw = false,
    this.isGifted = false,
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
      'isWithdraw': isWithdraw,
      'isGifted': isGifted,
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
    int? bestByYear,
    bool? isWithdraw,
    bool? isGifted,
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
      bestByYear: bestByYear?? this.bestByYear,
      isWithdraw: isWithdraw?? this.isWithdraw,
      isGifted: isGifted?? this.isGifted,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
