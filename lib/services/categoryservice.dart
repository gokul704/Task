import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future<List<String>> getCategories() async {
  final response = await http.get(
    Uri.parse("https://fakestoreapi.com/products/"),
  );
  if (response.statusCode == 200) {
    List<String> myList = jsonDecode(response.body);
    return myList;
  } else {
    return [];
  }
}
