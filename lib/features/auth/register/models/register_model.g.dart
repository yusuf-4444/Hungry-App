// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(data: Data.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  token: json['token'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'token': instance.token,
  'name': instance.name,
  'email': instance.email,
  'image': instance.image,
};
