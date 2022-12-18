class IsbnProfile {

  String name;
  String author;
  String publisher;
  String publicationYear;
  String classNumber;
  String cutterNumber;
  String picture;

  IsbnProfile(this.name, this.author, this.publisher, this.publicationYear,
      this.classNumber, this.cutterNumber, this.picture);

  factory IsbnProfile.fromJson(Map<String, dynamic> json){
    return IsbnProfile(
        json["name"] as String,
        json["author"] as String,
        json["publisher"] as String,
        json["publication-year"] as String,
        json["class-number"] as String,
        json["cutter-number"] as String,
        json["picture"] as String
    );
  }
}
