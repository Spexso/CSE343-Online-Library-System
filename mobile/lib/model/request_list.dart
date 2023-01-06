class RequestList {

  String isbn;
  String availableBooks;
  String position;
  String validUntil;

  RequestList(this.isbn, this.availableBooks, this.position, this.validUntil);

  factory RequestList.fromJson(Map<String, dynamic> json){
    return RequestList(
        json["isbn"] as String,
        json["available-books"] as String,
        json["position"] as String,
        json["valid-until"] as String,
    );
  }

}
