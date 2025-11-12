import 'package:json_annotation/json_annotation.dart';

part 'delete_item_model.g.dart';

@JsonSerializable()
class DeleteItemModel {
  final int code;
  final String message;
  final List? data;

  DeleteItemModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory DeleteItemModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteItemModelToJson(this);
}
