// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['customerId'] as String?,
      name: json['name'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      point: json['point'] as int? ?? 0,
      pointLon: json['pointLon'] as int? ?? 0,
      owe: json['owe'] as int? ?? 0,
      bestByYear: json['bestByYear'] as int? ?? 0,
      bestByYear2024: json['bestByYear2024'] as int? ?? 0,
      isWithdraw: json['isWithdraw'] as bool? ?? false,
      isGifted: json['isGifted'] as bool? ?? false,
      isAutumnGift: json['isAutumnGift'] as bool? ?? false,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerId': instance.id,
      'createTime': instance.createTime?.toIso8601String(),
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'point': instance.point,
      'pointLon': instance.pointLon,
      'owe': instance.owe,
      'bestByYear': instance.bestByYear,
      'bestByYear2024': instance.bestByYear2024,
      'isWithdraw': instance.isWithdraw,
      'isGifted': instance.isGifted,
      'isAutumnGift': instance.isAutumnGift,
    };
