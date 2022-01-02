// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_entity.dart';


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerEntity _$CustomerEntityFromJson(Map<String, dynamic> json) => CustomerEntity(
      id: json['customerId'] as String,
      name: json['name'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      totalPointThuong: (json['totalPointThuong'] ?? 0) as int,
      totalPointSuaLon: (json['totalPointSuaLon'] ?? 0) as int,
      tienNo: (json['tienNo'] ?? 0) as int,
    );

Map<String, dynamic> _$CustomerEntityToJson(CustomerEntity instance) =>
    <String, dynamic>{
      'customerId': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'createTime': instance.createTime!.toIso8601String(),
      'totalPointThuong': instance.totalPointThuong,
      'totalPointSuaLon': instance.totalPointSuaLon,
      'tienNo': instance.tienNo,
    };