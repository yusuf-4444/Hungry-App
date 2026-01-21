// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final Data data;

  ProfileModel({required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({Data? data}) {
    return ProfileModel(data: data ?? this.data);
  }
}

@JsonSerializable()
class Data {
  final String name;
  final String email;
  final String? image;
  final String? address;
  final String? visa;

  Data({
    required this.name,
    required this.email,
    this.image,
    this.address,
    this.visa,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);

  Data copyWith({
    String? name,
    String? email,
    String? image,
    String? address,
    String? visa,
  }) {
    return Data(
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      address: address ?? this.address,
      visa: visa ?? this.visa,
    );
  }
}
