import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel {
  final Data data;

  RegisterModel({required this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

@JsonSerializable()
class Data {
  final String token;
  final String name;
  final String email;
  final String image;

  Data({
    required this.token,
    required this.name,
    required this.email,
    required this.image,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
