class IsbnPicture {

  String picture;

  IsbnPicture(this.picture);

  factory IsbnPicture.fromJson(Map<String, dynamic> json){
    return IsbnPicture(
      json["picture"] as String,
    );
  }
}