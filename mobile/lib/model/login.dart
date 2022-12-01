class Login {

  String token;

  Login(this.token);

  factory Login.fromJson(Map<String, dynamic> json){
    return Login(
        json["token"] as String,
    );
  }
}