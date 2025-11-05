import 'package:json_annotation/json_annotation.dart';

part 'food_data_model.g.dart';

@JsonSerializable()
class FoodDataModel {
  final List<Data> data;

  FoodDataModel({required this.data});

  factory FoodDataModel.fromJson(Map<String, dynamic> json) =>
      _$FoodDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$FoodDataModelToJson(this);
}

@JsonSerializable()
class Data {
  final int id;
  final String name;
  final String description;
  final String image;
  final String rating;
  final String price;

  Data({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
