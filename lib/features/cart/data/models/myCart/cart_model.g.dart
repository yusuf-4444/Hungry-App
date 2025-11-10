// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
  data: CartItemsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
  'data': instance.data,
};

CartItemsData _$CartItemsDataFromJson(Map<String, dynamic> json) =>
    CartItemsData(
      id: (json['id'] as num).toInt(),
      totalPrice: json['total_price'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartItemsDataToJson(CartItemsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total_price': instance.totalPrice,
      'items': instance.items,
    };

ItemData _$ItemDataFromJson(Map<String, dynamic> json) => ItemData(
  itemId: (json['item_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: json['price'] as String,
  spicy: json['spicy'] as String,
  toppings: (json['toppings'] as List<dynamic>)
      .map((e) => Toppings.fromJson(e as Map<String, dynamic>))
      .toList(),
  sideOptions: (json['side_options'] as List<dynamic>)
      .map((e) => SideOptions.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ItemDataToJson(ItemData instance) => <String, dynamic>{
  'item_id': instance.itemId,
  'product_id': instance.productId,
  'name': instance.name,
  'image': instance.image,
  'quantity': instance.quantity,
  'price': instance.price,
  'spicy': instance.spicy,
  'toppings': instance.toppings,
  'side_options': instance.sideOptions,
};

Toppings _$ToppingsFromJson(Map<String, dynamic> json) => Toppings(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$ToppingsToJson(Toppings instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
};

SideOptions _$SideOptionsFromJson(Map<String, dynamic> json) => SideOptions(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$SideOptionsToJson(SideOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
