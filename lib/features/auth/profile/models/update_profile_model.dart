import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_model.g.dart';

@JsonSerializable()
class UpdateProfileModel {
  final Data data;

  UpdateProfileModel({required this.data});

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileModelToJson(this);
}

@JsonSerializable()
class Data {
  final String? image;
  final String name;
  final String email;
  final String? delivaryAddress;
  final String? visa;

  Data({
    required this.image,
    required this.name,
    required this.email,
    required this.delivaryAddress,
    required this.visa,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
