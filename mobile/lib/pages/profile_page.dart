import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page/model/user_profile.dart';
import 'package:login_page/pages/login_page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/error_message.dart';

//import 'package:library_project/edit_profile_page.dart';
//import 'package:library_project/user.dart';
//import 'package:library_project/user_preferences.dart';
//import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // to do: taken from database

  String? name;
  String? surname;
  String? email;
  String? phone;
  String? password;
  
  Future<UserProfile> userProfile() async {
    
    var url = Uri.parse("http://10.0.2.2:8080/user/user-profile");

    var answer = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    var resp = UserProfile("", "", "", "");

    if(answer.statusCode == 200){
      print("user profile success");
      resp = UserProfile.fromJson(json.decode(answer.body));
      return resp;
      /*
      name = resp.name;
      surname = resp.surname;
      email = resp.email;
      phone = resp.phone;  */
    }
    else if(answer.statusCode == 400){
      print("user profile not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.message);
    }
    return resp;
  }

  @override
  void initState() {
    userProfile().then((value){
      name = value.name;
      surname = value.surname;
      email = value.email;
      print(name);
      print(surname);
    });
    print(name);
    print(surname);
    super.initState();
  }

  late TextEditingController nameController =
      TextEditingController(text: name);
  late TextEditingController emailController =
      TextEditingController(text: surname);
  late TextEditingController passwordController =
      TextEditingController(text: password);

  late bool _isEnable = false;
  bool passenable = true;

  late bool _isObscure = true;



  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uyarı"),
          content: const Text(
            "Girilen bilgileri kayıt etmek istediğinize emin misiniz?",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              child: const Text("Evet"),
              onPressed: () {
                setState(() {
                  _isObscure = true;
                  _isEnable = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                    controller: nameController,
                    enabled: _isEnable,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                    controller: emailController,
                    enabled: _isEnable,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  TextField(
                    obscureText: _isObscure,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                    controller: passwordController,
                    enabled: _isEnable,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // to do: profili düzenle butonu dönüşcek veya kaydetmek için 2 buton?
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEnable = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                        primary: Colors.white),
                    child: const Text(
                      "Profili Düzenle",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check_box,
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _showDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.white54,
            ),

            // MENU
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 225,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(100, 100, 100, 1),
                      side: const BorderSide(color: Colors.grey)),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Cezalar",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SizedBox(
                width: 225,
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(100, 100, 100, 1),
                        side: const BorderSide(color: Colors.grey)),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Okunmuş Kitaplar",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 225,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(100, 100, 100, 1),
                      side: const BorderSide(color: Colors.grey)),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Çıkış Yap",
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*
  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontSize: 30),
          ),
        ],
      ); */
}
