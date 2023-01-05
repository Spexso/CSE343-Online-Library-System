class SavedBooks {
   List<String> books;

   SavedBooks({
    required this.books
  });

  factory SavedBooks.fromJson(Map<String, dynamic> parsedJson) {
    var booksFromJson  = parsedJson['isbn-list'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> booksList = booksFromJson.cast<String>();

    return  SavedBooks(
       books: booksList,
    );


  }

   List<String> toList({bool growable = true}) {
     return books.toList(growable: growable);
   }
}