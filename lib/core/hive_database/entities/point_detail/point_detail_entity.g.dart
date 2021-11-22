// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointDetailEntityAdapter extends TypeAdapter<PointDetailEntity> {
  @override
  final int typeId = 2;

  @override
  PointDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointDetailEntity(
      id: fields[0] as String?,
      customerId: fields[1] as String,
      point: fields[2] as int,
      comment: fields[3] as String,
      type: fields[4] as int,
      pushSuccess: fields[5] as bool
    );
  }

  @override
  void write(BinaryWriter writer, PointDetailEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(5)
      ..write(obj.pushSuccess)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.point)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      pushSuccess: true,
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