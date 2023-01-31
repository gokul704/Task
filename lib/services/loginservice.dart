import 'dart:convert';
import 'dart:developer';

import '../models/token.model.dart';
import 'package:http/http.dart' as http;

Future<TokenModel?> login(String userName, String passWord) async {
  TokenModel? result;
  Map data = {};
  if (userName.isEmpty && passWord.isNotEmpty) {
    data['username'] = userName;
    data['password'] = passWord;
  }
  try {
    final response = await http
        .post(Uri.parse('https://fakestoreapi.com/auth/login'), body: data);
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = TokenModel.fromJson(item);
    } else {
      print("error");
    }
  } catch (e) {
    log(e.toString());
  }
  return result;
}
