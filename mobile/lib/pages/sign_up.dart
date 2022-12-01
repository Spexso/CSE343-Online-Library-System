import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_page/model/user_login_api.dart';
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
      content: Text("Hata")
  );

  UserLoginApi parseSignUp(String ans) {
    return UserLoginApi.fromJson(json.decode(ans));
  }

  Future<bool> allSignUp() async {
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
      UserLoginApi resp = UserLoginApi.fromJson(json.decode(answer.body));
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
              color: Colors.white,
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
                    controller: _tfNameController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        hintText: "İsim",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _tfSurnameController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        hintText: "Soyisim",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _tfEmailController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.mail),
                        hintText: "Email",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _tfKeyController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.password),
                        hintText: "Şifre",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _tfPhoneController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.phone),
                        hintText: "Telefon",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
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
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            onPressed: () async {

                              var ans = await allSignUp();

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
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            )
                        ),

                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Zaten Hesabım Var',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                    fontSize: 18)))
                    ]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
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


