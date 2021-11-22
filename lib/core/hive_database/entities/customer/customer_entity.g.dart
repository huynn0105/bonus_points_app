// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerEntityAdapter extends TypeAdapter<CustomerEntity> {
  @override
  final int typeId = 1;

  @override
  CustomerEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerEntity(
      id: fields[0] as String?,
      name: fields[1] as String,
      phoneNumber: fields[2] as String?,
      address: fields[3] as String?,
      pushSuccess: fields[4] as bool
    );
  }

  @override
  void write(BinaryWriter writer, CustomerEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.pushSuccess)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerEntity _$CustomerEntityFromJson(Map<String, dynamic> json) => CustomerEntity(
      id: json['customerId'] as String,
      name: json['name'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      pushSuccess: true,
    );

Map<String, dynamic> _$CustomerEntityToJson(CustomerEntity instance) =>
    <String, dynamic>{
      'customerId': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'createTime': instance.createTime!.toIso8601String(),
    };