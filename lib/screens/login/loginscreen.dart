import 'dart:convert';

import 'package:example/screens/home/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/index.dart';
import 'package:http/http.dart' as http;
import '../../models/token.model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = const FlutterSecureStorage();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordHidden = true;
  bool _savePassword = true;

  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    customText(
                        txt: "Login Now",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    customText(
                        txt: "Please login to continue using our app.",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 60,
                    ),
                    customText(
                        txt: "Enter via social networks",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: InkwellButtons(
                              image: Image.asset("images/img3.png")),
                          onTap: () {},
                        ),
                        const SizedBox(width: 37),
                        InkWell(
                          child: InkwellButtons(
                              image: Image.asset("images/img4.png")),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    customText(
                        txt: "or login with email",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 5,
                            color: AppColors.kDarkblack,
                            style: BorderStyle.solid,
                          ))),
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "password",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 5,
                            color: AppColors.kDarkblack,
                            style: BorderStyle.solid,
                          ))),
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _value,
                          onChanged: (newValue) {
                            setState(() {
                              _value = newValue!;
                            });
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.kBlackColor),
                            );
                          },
                        ),
                        Spacer(),
                        const TextButton(
                          onPressed: null,
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    InkWell(
                      child: SignUpContainer(st: "LogIn"),
                      onTap: () async {
                        Map data = {};

                        if (usernameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          data['username'] = usernameController.text;
                          data['password'] = passwordController.text;
                          Response response = await http.post(
                              Uri.parse('https://fakestoreapi.com/auth/login'),
                              body: data);
                          if (response.statusCode == 200) {
                            var result = jsonDecode(response.body);
                            TokenModel token = TokenModel.fromJson(result);
                            // await _storage.write(
                            //     key: "token", value: token.token);
                            // var readData = await _storage.read(
                            //   key: "token",
                            // );
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                'AccessToken', token.token.toString());

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()));
                          } else {
                            print(response.statusCode);
                          }
                        }
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const WelcomeScreen()));
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      child: RichText(
                        text: RichTextSpan(
                            one: "Don’t have an account ? ", two: "Sign Up"),
                      ),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const SignupScreen()));
                      },
                    ),
                    //Text("data"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
