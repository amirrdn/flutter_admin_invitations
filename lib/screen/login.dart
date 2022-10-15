// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

import '../network/api.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email, password;
  bool _secureText = true;
  final Color myHexColor = const Color(0xffaf1f24);
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ])),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: LottieBuilder.asset("assets/lottie/login2.json"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 325,
                  height: 470,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Hello",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Please Login to Your Account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          width: 260,
                          height: 60,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.red,
                                ),
                                labelText: "Email Address",
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return 'Please enter your email';
                              }
                              email = emailValue;
                              return null;
                            },
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Colors.red,
                                ),
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            validator: (passwordValue) {
                              if (passwordValue!.isEmpty) {
                                return 'Please enter your password';
                              }
                              password = passwordValue;
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _login();
                              },
                              child: const Text(
                                "Forget Password",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF8A2387),
                                    Color(0xFFE94057),
                                    Color(0xFFF27121),
                                  ])),
                          child: TextButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              child: Text(
                                _isLoading ? 'Proccessing..' : 'Login',
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};
    var res = await Network().auth(data, 'check/login');
    var body = json.decode(res.body);
    print(body);
    if (body == 'Wrong Password') {
      setState(() {
        _isLoading = false;
      });
    } else if (body['success']) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', body['access_token']);
      prefs.setString('user', json.encode(body['users']));
      prefs.setBool('isLoggedIn', body['isLoggedIn']);
      // ignore: unused_local_variable
      String accessToken = body['access_token'];
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
      /*
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      */
    }

    setState(() {
      _isLoading = false;
    });
  }
}
