class SavedBooks {
   List<String> books;

   SavedBooks({
    required this.books
  });

  factory SavedBooks.fromJson(Map<String, dynamic> parsedJson) {
    var booksFromJson  = parsedJson['streets'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> streetsList = booksFromJson.cast<String>();

    return  SavedBooks(
      books: booksFromJson,
    );
  }

}