class IsbnList {

  String isbn;
  String name;
  String author;
  String publisher;
  String publicationYear;
  String classNumber;
  String cutterNumber;
  String picture;


  IsbnList(this.isbn, this.name, this.author, this.publisher,
      this.publicationYear, this.classNumber, this.cutterNumber, this.picture);

  factory IsbnList.fromJson(Map<String, dynamic> json){
    return IsbnList(
        json["isbn"] as String,
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
