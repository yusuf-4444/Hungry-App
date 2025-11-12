import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_to_cart_response_model.g.dart';

@JsonSerializable()
class AddToCartResponseModel {
  final int code;
  final String message;
  final Map<String, dynamic>? data;

  AddToCartResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddToCartResponseModelToJson(this);
}
