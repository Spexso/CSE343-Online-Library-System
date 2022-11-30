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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: const InputDecoration(icon: Icon(Icons.person)),
                controller: _nameController,
                enabled: _isEnable,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: const InputDecoration(icon: Icon(Icons.mail)),
                controller: _emailController,
                enabled: _isEnable,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: const InputDecoration(icon: Icon(Icons.password)),
                obscureText: passenable,
                controller: _passwordController,
                enabled: _isEnable,
                /*
                decoration: InputDecoration(
                  suffix: IconButton(
                    onPressed: () { //add Icon button at end of TextField
                      setState(() { //refresh UI
                        if(passenable){
                          passenable = false;
                        } else {
                          passenable = true;
                          }
                        });
                      },
                      icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password)
                  ),
                ),
                 */
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEnable = true;
                      });
                    },
                    child: const Text("Düzenle", style: TextStyle(color: Colors.white ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEnable = false;
                        });
                      },
                      child: const Text("Kaydet", style: TextStyle(color: Colors.white ),),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cezalar", style: TextStyle(color: Colors.white ),),
                      Icon(Icons.arrow_forward_outlined, color: Colors.white,)
                    ],
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 125,
                child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop(); // exit from app
                    },
                    child: Text("Çıkış Yap", style: TextStyle(color: Colors.white ),),
                ),
              ),
            ),
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
