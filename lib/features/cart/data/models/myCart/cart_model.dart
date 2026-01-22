// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final CartItemsData data;

  CartModel({required this.data});

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

@JsonSerializable()
class CartItemsData {
  final int id;

  @JsonKey(name: "total_price")
  final String totalPrice;

  final List<ItemData> items;

  CartItemsData({
    required this.id,
    required this.totalPrice,
    required this.items,
  });

  factory CartItemsData.fromJson(Map<String, dynamic> json) =>
      _$CartItemsDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemsDataToJson(this);

  CartItemsData copyWith({int? id, String? totalPrice, List<ItemData>? items}) {
    return CartItemsData(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      items: items ?? this.items,
    );
  }
}

@JsonSerializable()
class ItemData {
  @JsonKey(name: "item_id")
  final int itemId;

  @JsonKey(name: "product_id")
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final String spicy;
  final List<Toppings> toppings;

  @JsonKey(name: "side_options")
  final List<SideOptions> sideOptions;

  ItemData({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) =>
      _$ItemDataFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDataToJson(this);
}

@JsonSerializable()
class Toppings {
  final int id;
  final String name;
  final String image;

  Toppings({required this.id, required this.name, required this.image});

  factory Toppings.fromJson(Map<String, dynamic> json) =>
      _$ToppingsFromJson(json);
  Map<String, dynamic> toJson() => _$ToppingsToJson(this);
}

@JsonSerializable()
class SideOptions {
  final int id;
  final String name;
  final String image;

  SideOptions({required this.id, required this.name, required this.image});

  factory SideOptions.fromJson(Map<String, dynamic> json) =>
      _$SideOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$SideOptionsToJson(this);
}
