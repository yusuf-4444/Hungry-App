// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteItemModel _$DeleteItemModelFromJson(Map<String, dynamic> json) =>
    DeleteItemModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] as List<dynamic>?,
    );

Map<String, dynamic> _$DeleteItemModelToJson(DeleteItemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
