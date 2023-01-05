import 'isbn_list.dart';

class IsbnListResponse {

  List<IsbnList> isbnList;

  IsbnListResponse(this.isbnList);

  factory IsbnListResponse.fromJson(Map<String, dynamic> json){

    var isbnListJson = json["isbn-list"] as List;
    List<IsbnList> isbnListList = isbnListJson.map((e) => IsbnList.fromJson(e)).toList();
    return IsbnListResponse(isbnListList);
  }
}

