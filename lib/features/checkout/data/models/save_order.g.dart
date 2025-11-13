// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveOrder _$SaveOrderFromJson(Map<String, dynamic> json) => SaveOrder(
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItems.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SaveOrderToJson(SaveOrder instance) => <String, dynamic>{
  'items': instance.items,
};

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
  productId: (json['product_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  spicy: (json['spicy'] as num).toDouble(),
  toppings: (json['toppings'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  sideOptions: (json['side_options'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'spicy': instance.spicy,
      'toppings': instance.toppings,
      'side_options': instance.sideOptions,
    };
