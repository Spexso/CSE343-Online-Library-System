class UserLoginApi {

  String kind;
  String message;

  UserLoginApi(this.kind, this.message);

  factory UserLoginApi.fromJson(Map<String, dynamic> json){
    return UserLoginApi(
        json["kind"] as String,
        json["message"] as String
    );
  }
}

// json["lostStatus"] as bool,