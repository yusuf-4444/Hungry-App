// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toppings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToppingsModel _$ToppingsModelFromJson(Map<String, dynamic> json) =>
    ToppingsModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ToppingsModelToJson(ToppingsModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
};
