import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/model/error_message.dart';

import '../model/login.dart';

class Requests {

  String email = "";
  String password = "";
  String token = "";

  Future<bool> signUp() async {
    String name = "john";
    String surname = "smith";
    String email = "js@example.com";
    String phone = "+123456789";
    String password = "123";

    var url = Uri.parse("http://localhost:8080/guest/user-register");
    var data = {
      "name": name,
      "surname": surname,
      "email": email,
      "phone": phone,
      "password": password,
    };

    var answer = await http.post(
      url,
      body: data
    );

    if (answer.statusCode == 200) {
      print("sucsesss signup 200");
      return true;
    }
    else {
      print("errorr signup");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));

      return false;
    }
  }

  Future<Login> loginState() async {

    var url = Uri.parse("http://10.0.2.2:8080/guest/user-login");
    var data = {
      "email": email,
      "password": password,
    };

    var body = json.encode(data);

    var answer = await http.post(
        url,
        body: body
    );

    Login resp = Login("");

    print("all log in");

    if(answer.statusCode == 200){
      print("login success");
      resp = Login.fromJson(json.decode(answer.body));
      token = resp.token;
      print(token);
      return resp;
    }
    else if(answer.statusCode == 400){
      print("login not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.message);
      //return false;
    }
    else {
      print("not 200 and 400");
      //return false;
    }
    return resp;
  }
}