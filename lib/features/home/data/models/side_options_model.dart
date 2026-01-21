import 'package:freezed_annotation/freezed_annotation.dart';

part 'side_options_model.g.dart';

@JsonSerializable()
class SideOptionsModel {
  final List<Data> data;

  SideOptionsModel({required this.data});

  factory SideOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$SideOptionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SideOptionsModelToJson(this);
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

SideOptionsModel sideOptionsModel = SideOptionsModel(data: []);
