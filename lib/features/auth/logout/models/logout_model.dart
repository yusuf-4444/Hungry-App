import 'package:json_annotation/json_annotation.dart';

part 'logout_model.g.dart';

@JsonSerializable()
class LogoutModel {
  final String code;
  final String message;
  final String data;

  LogoutModel({required this.code, required this.message, required this.data});

  factory LogoutModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutModelToJson(this);
}
