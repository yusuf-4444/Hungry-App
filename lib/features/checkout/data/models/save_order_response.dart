import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_order_response.g.dart';

@JsonSerializable()
class SaveOrderResponse {
  final int code;
  final String message;
  final OrderData data;

  SaveOrderResponse({
    required this.code,
    required this.message,
    required this.data,
  });
  factory SaveOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$SaveOrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SaveOrderResponseToJson(this);
}

@JsonSerializable()
class OrderData {
  @JsonKey(name: "order_id")
  final int orderId;

  OrderData({required this.orderId});

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}
