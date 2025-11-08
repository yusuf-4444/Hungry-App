// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    ProfileModel(data: Data.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  name: json['name'] as String,
  email: json['email'] as String,
  image: json['image'] as String?,
  address: json['address'] as String?,
  visa: json['Visa'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'image': instance.image,
  'address': instance.address,
  'visa': instance.visa,
};
