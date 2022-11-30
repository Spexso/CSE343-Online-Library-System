import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:library_project/edit_profile_page.dart';
//import 'package:library_project/user.dart';
//import 'package:library_project/user_preferences.dart';
//import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // to do: taken from database

  late String name = "berry lafci";
  late String surname = "aaa@gtu.edu.tr";
  late String password = "abcd";

  late final TextEditingController _nameController =
      TextEditingController(text: name);
  late final TextEditingController _emailController =
      TextEditingController(text: surname);
  late final TextEditingController _passwordController =
      TextEditingController(text: password);

  late bool _isEnable = false;
  bool passenable = true;

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
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png")),
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
                    controller: _nameController,
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                      primary: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      "Profili Düzenle",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
            const Divider(),

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
                        style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
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
                    Navigator.pop(context);
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
                        style: TextStyle(color: Colors.red),
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
