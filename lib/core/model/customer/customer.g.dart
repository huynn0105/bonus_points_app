// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerEntityFromJson(Map<String, dynamic> json) => Customer(
      id: json['customerId'] as String,
      name: json['name'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      point: (json['point'] ?? 0) as int,
      point1: (json['point1'] ?? 0) as int,
      owe: (json['owe'] ?? 0) as int,
    );

// Customer _$CustomerEntityFromJson(Map<String, dynamic> json) => Customer(
//       id: json['customerId'] as String,
//       name: json['name'] as String,
//       createTime: DateTime.parse(json['createTime'] as String),
//       address: json['address'] as String?,
//       phoneNumber: json['phoneNumber'] as String?,
//       point: (json['totalPointThuong'] ?? 0) as int,
//       point1: (json['totalPointSuaLon'] ?? 0) as int,
//       owe: (json['tienNo'] ?? 0) as int,
//     );

Map<String, dynamic> _$CustomerEntityToJson(Customer instance) =>
    <String, dynamic>{
      'customerId': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'createTime': instance.createTime!.toIso8601String(),
      'point': instance.point,
      'point1': instance.point1,
      'owe': instance.owe,
    };
