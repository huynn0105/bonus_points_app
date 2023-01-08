// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointDetail _$PointDetailFromJson(Map<String, dynamic> json) => PointDetail(

      customerId: json['customerId'] as String,
      value: json['value'] as int,
      createTime: DateTime.parse(json['createTime'] as String),
      comment: json['comment'] as String,
      id: json['id'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$PointDetailToJson(PointDetail instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'comment': instance.comment,
      'value': instance.value,
      'createTime': instance.createTime!.toIso8601String(),
      'id': instance.id,
      'type': instance.type,
    };
