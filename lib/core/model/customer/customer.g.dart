// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
         id: json['customerId'] as String,
      name: json['name'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      point: (json['point'] ?? 0) as int,
      point1: (json['point1'] ?? 0) as int,
      owe: (json['owe'] ?? 0) as int,
      bestByYear: json['bestByYear'] as int? ?? 0,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerId': instance.id,
      'createTime': instance.createTime?.toIso8601String(),
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'point': instance.point,
      'point1': instance.point1,
      'owe': instance.owe,
      'bestByYear': instance.bestByYear,
    };
