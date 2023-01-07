class BorrowedList {

  String id;
  String isbn;
  String dueDate;
  String name;
  String author;
  String publisher;
  String publicationYear;
  String classNumber;
  String cutterNumber;
  String picture;

  BorrowedList(
      this.id,
      this.isbn,
      this.dueDate,
      this.name,
      this.author,
      this.publisher,
      this.publicationYear,
      this.classNumber,
      this.cutterNumber,
      this.picture);

  factory BorrowedList.fromJson(Map<String, dynamic> json){
    return BorrowedList(
        json["id"] as String,
        json["isbn"] as String,
        json["due-date"] as String,
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


