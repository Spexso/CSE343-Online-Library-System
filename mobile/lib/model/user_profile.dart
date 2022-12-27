class UserProfile {

  String name;
  String surname;
  String email;
  String phone;

  UserProfile(this.name, this.surname, this.email, this.phone);

  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
      json["name"] as String,
      json["surname"] as String,
      json["email"] as String,
      json["phone"] as String,
    );
  }
}