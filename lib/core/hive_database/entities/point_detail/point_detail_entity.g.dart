// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_detail_entity.dart';



// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointDetailEntity _$PointDetailEntityFromJson(Map<String, dynamic> json) =>
    PointDetailEntity(
      customerId: json['customerId'] as String,
      point: json['point'] as int,
      createTime: DateTime.parse(json['createTime'] as String),
      comment: json['comment'] as String,
      id: json['id'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$PointDetailEntityToJson(PointDetailEntity instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'comment': instance.comment,
      'point': instance.point,
      'createTime': instance.createTime!.toIso8601String(),
      'id': instance.id,
      'type': instance.type,
    };