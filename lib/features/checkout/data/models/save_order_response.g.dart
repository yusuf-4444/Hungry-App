// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveOrderResponse _$SaveOrderResponseFromJson(Map<String, dynamic> json) =>
    SaveOrderResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaveOrderResponseToJson(SaveOrderResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

OrderData _$OrderDataFromJson(Map<String, dynamic> json) =>
    OrderData(orderId: (json['order_id'] as num).toInt());

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
  'order_id': instance.orderId,
};
