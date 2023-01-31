import 'dart:ffi';

import 'package:example/models/products/rate/rate.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products.model.g.dart';

@JsonSerializable()
class ProductsModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final RateModel? rating;

  ProductsModel(this.id, this.title, this.price, this.description,
      this.category, this.image, this.rating);

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return _$ProductsModelFromJson(map);
  }
  static List<ProductsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((e) => ProductsModel.fromMap(e)).toList();
  }

  factory ProductsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsModelToJson(this);
  Map<String, dynamic> toMap() {
    return _$ProductsModelToJson(this);
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
