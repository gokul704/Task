import 'dart:convert';
import 'dart:developer';

import 'package:example/models/products/products.model.dart';
import 'package:http/http.dart' as http;

Future<List<ProductsModel>> getProducts() async {
  ProductsModel? result;

  final response = await http.get(
    Uri.parse("https://fakestoreapi.com/products/"),
  );
  if (response.statusCode == 200) {
    List<dynamic> myList = jsonDecode(response.body);
    return myList.map((e) => ProductsModel.fromJson(e)).toList();
  } else {
    return [];
  }
}
