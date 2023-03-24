import 'package:bonus_points_app/core/model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class PointDetail extends BaseModel {
  String customerId;
  int value;
  String comment;
  int type; //0 = point (nomal) | 1 = point1 (milk bottle) | 2 = owe;
  

  PointDetail({
    String? id,
    DateTime? createTime,
    required this.customerId,
    required this.value,
    required this.comment,
    required this.type,
  }) : super(id: id, createTime: createTime);

  bool isEqual(PointDetail other) {
    return other.id == id &&
        other.createTime == createTime &&
        other.customerId == customerId &&
        other.comment == comment &&
        other.type == type &&
        other.value == value;
  }

    PointDetail copyWith({
    String? id,
    DateTime? createTime,
    String? customerId,
    int? value,
    String? comment,
    int ? type,

  }){
    return PointDetail(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      createTime: createTime ?? this.createTime,
      value: value ?? this.value,
      comment: comment ?? this.comment,
      type: type ?? this.type,
     
    );
  }

  factory PointDetail.fromJson(Map<String, dynamic> json) =>
      _$PointDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PointDetailToJson(this);
}
