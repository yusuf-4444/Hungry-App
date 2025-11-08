// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileModel _$UpdateProfileModelFromJson(Map<String, dynamic> json) =>
    UpdateProfileModel(
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateProfileModelToJson(UpdateProfileModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  image: json['image'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  delivaryAddress: json['delivaryAddress'] as String?,
  visa: json['visa'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'image': instance.image,
  'name': instance.name,
  'email': instance.email,
  'delivaryAddress': instance.delivaryAddress,
  'visa': instance.visa,
};
