import 'package:flutter/material.dart';
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
  //final user = UserPreferences.myUser;
  late String name = "berry";
  late String surname = "aaa";

  late final TextEditingController _nameController =
      TextEditingController(text: name);
  late final TextEditingController _surnameController =
      TextEditingController(text: surname);

  bool _isEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 97),
          child: Icon(
            Icons.person_pin,
            size: 75,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        toolbarHeight: 120,
        shadowColor: Colors.brown,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(250),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _nameController,
                      enabled: _isEnable,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEnable = true;
                        });
                      }),
                  IconButton(
                      icon: const Icon(Icons.check_rounded),
                      onPressed: () {
                        setState(() {
                          _isEnable = false;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _surnameController,
                      enabled: _isEnable,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEnable = true;
                        });
                      }),
                  IconButton(
                      icon: const Icon(Icons.check_rounded),
                      onPressed: () {
                        setState(() {
                          _isEnable = false;
                        });
                      }),
                ],
              ),
            ],
          ),
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
