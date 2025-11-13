import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_order.g.dart';

@JsonSerializable()
class SaveOrder {
  final List<OrderItems> items;

  SaveOrder({required this.items});

  factory SaveOrder.fromJson(Map<String, dynamic> json) =>
      _$SaveOrderFromJson(json);
  Map<String, dynamic> toJson() => _$SaveOrderToJson(this);
}

@JsonSerializable()
class OrderItems {
  @JsonKey(name: "product_id")
  final int productId;

  final int quantity;
  final double spicy;
  final List<int> toppings;

  @JsonKey(name: "side_options")
  final List<int> sideOptions;

  OrderItems({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) =>
      _$OrderItemsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}
