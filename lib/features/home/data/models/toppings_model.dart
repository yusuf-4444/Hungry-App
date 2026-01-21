import 'package:freezed_annotation/freezed_annotation.dart';

part 'toppings_model.g.dart';

@JsonSerializable()
class ToppingsModel {
  final List<Data> data;

  ToppingsModel({required this.data});

  factory ToppingsModel.fromJson(Map<String, dynamic> json) =>
      _$ToppingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ToppingsModelToJson(this);
}

@JsonSerializable()
class Data {
  final int id;
  final String name;
  final String image;

  Data({required this.id, required this.name, required this.image});
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

ToppingsModel toppingsModel = ToppingsModel(data: []);
