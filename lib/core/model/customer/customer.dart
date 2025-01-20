import 'package:bonus_points_app/core/model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends BaseModel {
  String name;
  String? phoneNumber;
  String? address;
  int point;
  int pointLon;
  int owe;
  int bestByYear;
  int bestByYear2024;
  bool isWithdraw;
  bool isGifted;
  bool isLunarGift;
  bool isAutumnGift;


  Customer({
    String? id,
    DateTime? createTime,
    required this.name,
    this.phoneNumber,
    this.address,
    this.point = 0,
    this.pointLon = 0,
    this.owe = 0,
    this.bestByYear = 0,
    this.bestByYear2024 = 0,
    this.isWithdraw = false,
    this.isGifted = false,
    this.isLunarGift = false,
    this.isAutumnGift = false,
  }) : super(id: id, createTime: createTime);

  Map<String, dynamic> get values {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'point': point,
      'pointLon': pointLon,
      'owe': owe,
      'createTime': createTime,
      'isWithdraw': isWithdraw,
      'bestByYear2024': bestByYear2024,
      'isGifted': isGifted,
      'isAutumnGift': isAutumnGift,
      'isLunarGift': isLunarGift,
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
    int? bestByYear2024,
    bool? isAutumnGift,
    bool? isLunarGift,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      createTime: createTime ?? this.createTime,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      owe: tienNo ?? this.owe,
      pointLon: totalPointSuaLon ?? this.pointLon,
      point: totalPointThuong ?? this.point,
      bestByYear: bestByYear?? this.bestByYear,
      bestByYear2024: bestByYear2024?? this.bestByYear2024,
      isWithdraw: isWithdraw ?? this.isWithdraw,
      isGifted: isGifted ?? this.isGifted,
      isLunarGift: isLunarGift ?? this.isLunarGift,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
