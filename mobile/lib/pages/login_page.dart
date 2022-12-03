import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_page/model/login.dart';
import 'package:login_page/pages/forgot_password.dart';
import 'package:login_page/pages/new_home_page.dart';
import '../model/error_message.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var snackBar = const SnackBar(content: Text("Login Error", style: TextStyle(fontSize: 25),), width: 10,);
  final _tfEmailController = TextEditingController();
  final _tfKeyController = TextEditingController();

  late String token;

  Future<bool> loginState() async {
    var url = Uri.parse("http://10.0.2.2:8080/guest/user-login");
    var data = {
      "email": _tfEmailController.text,
      "password": _tfKeyController.text,
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
            width: MediaQuery.of(context).size.width / 5 * 4,
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
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    controller: _tfEmailController,
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
                        hintStyle: const TextStyle(color: Colors.white),
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
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    obscureText: true,
                    controller: _tfKeyController,
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
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Checkbox(value: true, onChanged: null),
                        Text(
                          "Beni Hatırla",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()),
                              )
                            },
                        child: const Text(
                          'Şifremi Unuttum',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        )),
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
                            var ans = await loginState();

                            if (ans == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewHomePage(
                                          token: token,
                                        )),
                              );
                            } else if (ans == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                )
                              },
                          child: const Text('Kayıt Ol',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 18)))
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
          style: const TextStyle(fontSize: 20, color: Colors.black),
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
        ),
      ),
    );
  }
}
