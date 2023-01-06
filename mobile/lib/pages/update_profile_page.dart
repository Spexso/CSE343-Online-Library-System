import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/model/error_message.dart';
import 'package:login_page/pages/profile_page.dart';

class UpdateProfilePage extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String token;
  const UpdateProfilePage({Key? key,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.token
  }) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  late String name;
  late String surname;
  late String email;
  late String phone;
  late String password;

  late bool _isObscure = true;

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    surnameController = TextEditingController(text: widget.surname);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    passwordController = TextEditingController(text: "123");
  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<bool> changeUsername() async {

    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/change-user-name");

    var data = {
      "new-name": nameController.text,
      "new-surname": surnameController.text,
    };

    var body = json.encode(data);
    var answer = await http.post(
        url,
        body: body,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );
    print("update profile page");

    if(answer.statusCode == 200){
      print("username update success");
      return true;
    }
    else if(answer.statusCode == 400) {
      print("username update NOT success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
      print(resp.message);
      return false;
    }
    else {
      print("username update not 200 and 400");
      return false;
    }
  }

  Future<bool> changeUserEmail() async {

    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/change-user-email");

    var data = {
      "password": passwordController.text,
      "new-email": emailController.text,
    };

    var body = json.encode(data);
    var answer = await http.post(
        url,
        body: body,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    if(answer.statusCode == 200){
      print("email update success");
      return true;
    }
    else if(answer.statusCode == 400) {
      print("email update NOT success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
      print(resp.message);
      return false;
    }
    else {
      print("email update not 200 and 400");
      return false;
    }
  }

  Future<bool> changeUserPhone() async {

    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/change-user-phone");

    var data = {
      "password": passwordController.text,
      "new-phone": phoneController.text,
    };

    var body = json.encode(data);
    var answer = await http.post(
        url,
        body: body,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    if(answer.statusCode == 200){
      print("phone update success");
      return true;
    }
    else if(answer.statusCode == 400) {
      print("phone update NOT success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
      print(resp.message);
      return false;
    }
    else {
      print("email update not 200 and 400");
      return false;
    }
  }

  Future<bool> changeUserPassword() async {

    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/change-user-password");

    var data = {
      "old-password": passwordController.text,
      "new-password": passwordController.text,
    };

    var body = json.encode(data);
    var answer = await http.post(
        url,
        body: body,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    if(answer.statusCode == 200){
      print("phone update success");
      return true;
    }
    else if(answer.statusCode == 400) {
      print("phone update NOT success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
      print(resp.message);
      return false;
    }
    else {
      print("email update not 200 and 400");
      return false;
    }
  }

  late bool nameChange = false;
  late bool surnameChange = false;
  late bool emailChange = false;
  late bool phoneChange = false;
  late bool passwordChange = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(42, 43, 46, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                    controller: nameController,
                    onChanged: (text) {
                      setState(() {
                        print("name changed");
                        nameChange = true;
                      });
                    },
                    //enabled: _isEnable,
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                    controller: surnameController,
                    onChanged: (text) {
                      setState(() {
                        print("surname changed");
                        surnameChange = true;
                      });
                    },
                    //enabled: _isEnable,
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
                    onChanged: (text) {
                      setState(() {
                        print("email changed");
                        emailChange = true;
                      });
                    },
                    //enabled: _isEnable,
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
                    controller: phoneController,
                    onChanged: (text) {
                      setState(() {
                        print("phone changed");
                        phoneChange = true;
                      });
                    },
                    //enabled: _isEnable,
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
                    onChanged: (text) {
                      setState(() {
                        print("password changed");
                        passwordChange = true;
                      });
                    },
                    //enabled: _isEnable,
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
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {

                  bool errorFlag = false;

                  if(nameChange == true){
                    var ans = await changeUsername();

                    if(ans == true){
                      print("success update Username button");
                      //Navigator.pop(context);
                    }
                    else if(ans == false){
                      print("error update Username button");
                      errorFlag = true;
                    }
                  }

                  if(surnameChange == true){
                    var ans = await changeUsername();

                    if(ans == true){
                      print("success update Username button");
                      //Navigator.pop(context);
                    }
                    else if(ans == false){
                      print("error update Username button");
                      errorFlag = true;
                    }
                  }

                  if(emailChange == true){
                    var ans = await changeUserEmail();

                    if(ans == true){
                      print("success update Email button");
                      //Navigator.pop(context);
                    }
                    else if(ans == false){
                      print("error update Email button");
                      errorFlag = true;
                    }
                  }

                  if(phoneChange == true){
                    var ans = await changeUsername();

                    if(ans == true){
                      print("success update phone button");
                      //Navigator.pop(context);
                    }
                    else if(ans == false){
                      print("error update phone button");
                      errorFlag = true;
                    }
                  }

                  if(passwordChange == true){
                    var ans = await changeUsername();

                    if(ans == true){
                      print("success update password button");
                      //Navigator.pop(context);
                    }
                    else if(ans == false){
                      print("error update password button");
                      errorFlag = true;
                    }
                  }



                  if(errorFlag == false){
                    Navigator.pop(context);
                  }


                  /*
                  var ans = await changeUsername();
                  var ans1 = await changeUserEmail();
                  var ans2 = await changeUserPhone();

                  if((ans == true) && (ans1 == true) && (ans2 == true)){
                    print("success update profile button");
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(token: widget.token,)),);
                    Navigator.pop(context);
                  }
                  else if((ans == false) || (ans1 == false) || (ans2 == false)){
                    print("error update profile button");
                  } */
                },
                child: const Text("KAYDET"),
            ),
          ],
        ),
      ),
    );
  }
}
