import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_to_cart_model.g.dart';

@JsonSerializable()
class CartItems {
  final List<Item> items;

  CartItems({required this.items});

  factory CartItems.fromJson(Map<String, dynamic> json) =>
      _$CartItemsFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemsToJson(this);
}

@JsonSerializable()
class Item {
  @JsonKey(name: "product_id")
  final int productId;

  final int quantity;
  final double spicy;
  final List<int> toppings;

  @JsonKey(name: "side_options")
  final List<int> sideOptions;

  Item({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
