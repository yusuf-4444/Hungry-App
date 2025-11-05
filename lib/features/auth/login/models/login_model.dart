import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final Data data;

  LoginModel({required this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable()
class Data {
  final String token;
  final String email;
  final String name;
  final String image;

  Data({
    required this.token,
    required this.email,
    required this.name,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
