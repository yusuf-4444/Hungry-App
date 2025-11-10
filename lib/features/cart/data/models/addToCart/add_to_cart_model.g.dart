// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItems _$CartItemsFromJson(Map<String, dynamic> json) => CartItems(
  items: (json['items'] as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CartItemsToJson(CartItems instance) => <String, dynamic>{
  'items': instance.items,
};

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
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

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'product_id': instance.productId,
  'quantity': instance.quantity,
  'spicy': instance.spicy,
  'toppings': instance.toppings,
  'side_options': instance.sideOptions,
};
