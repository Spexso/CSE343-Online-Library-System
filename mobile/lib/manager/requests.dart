import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/model/error_message.dart';

class Requests {

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

}