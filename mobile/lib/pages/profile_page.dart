import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_page/model/suspend_until.dart';
import 'package:login_page/model/user_profile.dart';
import 'package:login_page/pages/borrowed_page.dart';
import 'package:login_page/pages/login_page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/pages/update_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/error_message.dart';

//import 'package:library_project/edit_profile_page.dart';
//import 'package:library_project/user.dart';
//import 'package:library_project/user_preferences.dart';
//import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  final String password;

  const ProfilePage({Key? key, required this.token, required this.password})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // to do: taken from database

  late String name;
  late String surname;
  late String email;
  late String phone;
  //String password = widget.password;

  //late String password;

  Future<String> suspendedUntil() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/suspended-until");
    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (answer.statusCode == 200) {
      print("DATE SUCCESS");
      var resp = SuspendUntil.fromJson(json.decode(answer.body));
      String dateTime;
      if ((int.parse(resp.timestamp)*1000) > currentTime) {
        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(resp.timestamp) * 1000);
        dateTime = "${tsdate.day}/${tsdate.month}/${tsdate.year}-${tsdate.hour}:${tsdate.minute}";
      } else {
        dateTime = "-";
      }

      return dateTime;
    } else {
      print("DATE ERROR");
      return "";
    }
  }

  Future<UserProfile> userProfile() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/user-profile");

    //var url = Uri.parse("http://10.0.2.2:8080/user/user-profile");

    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});

    var resp = UserProfile("", "", "", "");

    if (answer.statusCode == 200) {
      print("user profile success");
      resp = UserProfile.fromJson(json.decode(utf8.decode(answer.bodyBytes)));
      name = resp.name;
      surname = resp.surname;
      email = resp.email;
      phone = resp.phone;
      return resp;
    } else if (answer.statusCode == 400) {
      print("user profile not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.message);
    }
    return resp;
  }

  @override
  void initState() {
    userProfile().then((value) {});

    super.initState();
  }
/*
  late TextEditingController nameController =
      TextEditingController(text: name);
  late TextEditingController emailController =
      TextEditingController(text: surname);
  late TextEditingController phoneController =
      TextEditingController(text: phone);
  late TextEditingController passwordController =
      TextEditingController(text: widget.password); */

  late bool _isEnable = false;
  bool passenable = true;
  bool? rememberMe;

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

  Future<void> dataRead() async{
    var sp = await SharedPreferences.getInstance();

    setState(() {
      email = sp.getString("email") ?? "no name";
      //widget.password = sp.getString("password") ?? "no key";
      rememberMe = sp.getBool("remember_me") ?? false;
    });
  }

  Future<void> exit() async{
    var sp = await SharedPreferences.getInstance();

    if(rememberMe == false){
      sp.remove("email");
      sp.remove("password");
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uygulamadan çıkış yapmak istediğinize emin misiniz?', style: TextStyle(fontSize: 17),),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: Text('Hayır', style: TextStyle(color: Colors.cyan[800], fontSize: 15),),
          ),
          TextButton(
            onPressed: () => exit(), // <-- SEE HERE
            child: Text('Evet', style: TextStyle(color: Colors.cyan[800], fontSize: 15)),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //Text(dotenv.env['API_URL'] ?? "API_URL not found"),
            const SizedBox(
              width: 150,
              height: 20,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_photo.jpeg'),
              radius: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: userProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$name $surname",
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          email,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Ubuntu'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          phone,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Ubuntu'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("ERROR");
                }
                // else
                return CircularProgressIndicator(
                  color: Colors.white,
                );
              },
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
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfilePage(
                                  name: name,
                                  surname: surname,
                                  email: email,
                                  token: widget.token,
                                  phone: phone,
                                  password: widget.password,
                                )),
                      );
                      setState(() {});
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
                /*
                IconButton(
                  icon: const Icon(
                    Icons.check_box,
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _showDialog(context);
                  },
                ), */
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
                future: suspendedUntil(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.all(20),
                      height: 90,
                      width: 225,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(42, 43, 46, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: const Color.fromRGBO(100, 100, 100, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              snapshot.data!.toString(),
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const Divider(
                              thickness: 1,
                              color: const Color.fromRGBO(42, 43, 46, 1),
                            ),
                            const Text(
                              "Zamanına Kadar Ceza",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("ERROR");
                  }
                  // else
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                }),
            SizedBox(
              width: 225,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BorrowedPage(
                                token: widget.token,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(100, 100, 100, 1),
                      side: const BorderSide(
                        color: const Color.fromRGBO(42, 43, 46, 1),
                      )),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Kitaplarım",
                        style: TextStyle(color: Colors.white, fontSize: 17),
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
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: 225,
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      _onWillPop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(100, 100, 100, 1),
                        side: const BorderSide(
                          color: const Color.fromRGBO(42, 43, 46, 1),
                        )),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Çıkış Yap",
                          style: TextStyle(color: Colors.red, fontSize: 17),
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
