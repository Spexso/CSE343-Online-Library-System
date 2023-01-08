// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_page/model/login.dart';
import 'package:login_page/pages/forgot_password.dart';
import 'package:login_page/pages/new_home_page.dart';
import '../model/error_message.dart';
import 'sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var snackBar = const SnackBar(
      content: Text(
    "Login Error",
    style: TextStyle(fontFamily: 'Ubuntu'),
  ));

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late String token;

  bool _isChecked = false;

  Future<bool> loginState() async {


    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/guest/user-login");
    //var url = Uri.parse("http://10.0.2.2:8080/guest/user-login");
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    var body = json.encode(data);

    var answer = await http.post(url, body: body);

    print("all log in");

    if (answer.statusCode == 200) {
      print("login success");
      Login resp = Login.fromJson(json.decode(answer.body));
      token = resp.token;
      print(token);
      return true;
    } else if (answer.statusCode == 400) {
      print("login not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.message);
      return false;
    } else {
      print("not 200 and 400");
      return false;
    }
  }

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: ProjectUtility().customgradient(),
        //color: const Color.fromRGBO(42, 43, 46, 1),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 5 * 3,
            width: MediaQuery.of(context).size.width / 5 * 4.50,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CustomTitle(
                  str: 'Giriş Yap',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Ubuntu'),
                    controller: emailController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(42, 43, 46, 1),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintStyle: const TextStyle(
                          color: Colors.white, fontFamily: 'Ubuntu'),
                      suffixIcon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Ubuntu'),
                    obscureText: true,
                    controller: passwordController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      hintText: "Şifre",
                      filled: true,
                      fillColor: const Color.fromRGBO(42, 43, 46, 1),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintStyle: const TextStyle(
                          color: Colors.white, fontFamily: 'Ubuntu'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /*
                        CheckboxListTile(
                            value: _isChecked,
                            onChanged: _rememberMeCheckBox,
                            title: const Text("Beni Hatırla",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Ubuntu'),
                            ),
                        ) */

                        Checkbox(value: _isChecked, onChanged: _rememberMeCheckBox),
                        Text(
                          "Beni Hatırla",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Ubuntu'),
                        )
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            primary: Colors.white,
                          ),
                          onPressed: () async {

                            var sp = await SharedPreferences.getInstance();

                            var email = emailController.text;
                            var password = passwordController.text;

                            await SharedPreferences.getInstance();

                            var ans = await loginState();
                            print(ans);

                            if (ans == true) {
                              print("PASSWORD");
                              print(passwordController.text);
                              sp.setString("email", email);
                              sp.setString("password", password);
                              sp.setBool("remember_me", _isChecked);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewHomePage(
                                          token: token,
                                          password: passwordController.text,
                                        )),
                              );
                            } else if (ans == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold),
                          )
                      ),
                      TextButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpPage()),
                                )
                              },
                          child: const Text('Kayıt Ol',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Ubuntu',
                              )
                          )
                      )
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

  void _rememberMeCheckBox(bool? value) {

    _isChecked = value!;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
      prefs.setString("email", emailController.text);
      prefs.setString("password", passwordController.text);
    },
    );
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserEmailPassword() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("email") ?? "";
      String? password = prefs.getString("password") ?? "";
      bool? rememberMe = prefs.getBool("remember_me") ?? false;

      if (rememberMe) {
        setState(() {
          _isChecked = true;
        });
        emailController.text = email;
        passwordController.text = password;
      }
    } catch (e) {
      print(e);
    }
  }


}

class ProjectUtility {
  BoxDecoration customgradient() {
    return const BoxDecoration(
        gradient: LinearGradient(
      colors: [Colors.cyan, Colors.black],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ));
  }
}

class CustomButton extends StatelessWidget {
  final String title;

  const CustomButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: () => {},
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontFamily: 'Ubuntu'),
        ));
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black,
      endIndent: 150,
      thickness: 1,
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String str;

  const CustomTitle({
    Key? key,
    required this.str,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        str,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Colors.white,
            fontFamily: 'Ubuntu',
        ),
      ),
    );
  }
}
