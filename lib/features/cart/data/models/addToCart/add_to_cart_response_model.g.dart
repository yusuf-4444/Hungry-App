// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartResponseModel _$AddToCartResponseModelFromJson(
  Map<String, dynamic> json,
) => AddToCartResponseModel(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'] as Map<String, dynamic>,
);

Map<String, dynamic> _$AddToCartResponseModelToJson(
  AddToCartResponseModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};
