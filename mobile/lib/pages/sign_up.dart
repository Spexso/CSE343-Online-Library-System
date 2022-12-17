// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_page/model/error_message.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

import 'package:login_page/manager/requests.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var snackBar = const SnackBar(
      content: Text("Sign Up Error")
  );
/*
  ErrorMessage parseSignUp(String ans) {
    return ErrorMessage.fromJson(json.decode(ans));
  } */

  Future<bool> signUpState() async {
    String name = "";
    String surname = "";
    String email = "";
    String phone = "";
    String password = "";

    var url = Uri.parse("http://10.0.2.2:8080/guest/user-register");
    var data = {
      "name": _tfNameController.text,
      "surname": _tfSurnameController.text,
      "email": _tfEmailController.text,
      "phone": _tfPhoneController.text,
      "password": _tfKeyController.text,
    };

    var body = json.encode(data);

    var answer = await http.post(
        url,
        body: body
    );

    print("all sign up");

    if (answer.statusCode == 200) {
      print("sucsesss signup 200");
      return true;
    }
    else if(answer.statusCode == 400) {
      print("errorr signup");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      //print(resp);
      print(resp.kind);
      print(resp.message);
      return false;
    }
    else {
      print("not 200 and 400");
      return false;
    }

    //return parseSignUp(answer.body);
  }


  final _tfNameController = TextEditingController();
  final _tfSurnameController = TextEditingController();
  final _tfEmailController = TextEditingController();
  final _tfKeyController = TextEditingController();
  final _tfPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: ProjectUtility().customgradient(),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height / 40 * 32,
              width: MediaQuery.of(context).size.width / 5 * 4,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomTitle(
                    str: 'Kayıt Ol',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      controller: _tfNameController,
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
                          suffixIcon: const Icon(Icons.person, color: Colors.white,),
                          hintText: "İsim",
                          border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      controller: _tfSurnameController,
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
                          suffixIcon: const Icon(Icons.person, color: Colors.white,),
                          hintText: "Soyisim",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
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
                          suffixIcon: const Icon(Icons.mail, color: Colors.white,),
                          hintText: "Email",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      controller: _tfKeyController,
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
                          suffixIcon: const Icon(Icons.password, color: Colors.white,),
                          hintText: "Şifre",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      controller: _tfPhoneController,
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
                          suffixIcon: const Icon(Icons.phone, color: Colors.white,),
                          hintText: "Telefon",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Center(
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                onPressed: () async {

                                  var ans = await signUpState();

                                  if(ans == true){
                                    print("trueee2");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const LoginPage()),
                                    );
                                  }
                                  else{
                                    print("idk2");
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: const Text(
                                  "Kayıt Ol",
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                )
                            ),
                          ),

                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Zaten Hesabım Var',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18)))
                      ]
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

/*
SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTitle(
                str: 'Kayıt Ol',
              ),
              const CustomDivider(),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'İsim', a: Icons.person),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Soyisim', a: Icons.person),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Email', a: Icons.email),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Şifre', a: Icons.password),
              const SizedBox(height: 50),
              Center(
                child: Column(children: [
                  const CustomButton(title: 'Kayıt Ol'),
                  TextButton(
                      onPressed: () => {
                            Navigator.pop(context),
                          },
                      child: const Text('Zaten Hesabım Var',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 18)))
                ]),
              )
            ],
          ),
        ),
      ),
 */


//Future<Datas> a = dataSearch();
//a.then((value) => print(value.toString()));


