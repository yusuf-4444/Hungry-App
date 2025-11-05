// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) =>
    LoginModel(data: Data.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  token: json['token'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'token': instance.token,
  'email': instance.email,
  'name': instance.name,
  'image': instance.image,
};
