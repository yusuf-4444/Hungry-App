// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodDataModel _$FoodDataModelFromJson(Map<String, dynamic> json) =>
    FoodDataModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FoodDataModelToJson(FoodDataModel instance) =>
    <String, dynamic>{'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  image: json['image'] as String,
  rating: json['rating'] as String,
  price: json['price'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image,
  'rating': instance.rating,
  'price': instance.price,
};
