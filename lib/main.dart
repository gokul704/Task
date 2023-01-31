import 'package:example/providers/cartprovider.dart';
import 'package:example/screens/home/welcome.dart';
import 'package:example/screens/login/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('AccessToken');

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
          title: 'Demo',
          debugShowCheckedModeBanner: false,
          home: token == Null ? const LoginScreen() : const Dashboard())));
}
