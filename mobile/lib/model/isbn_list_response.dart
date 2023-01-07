import 'package:login_page/model/isbn_list.dart';

class IsbnListResponse {

  List<IsbnList> isbnList;

  IsbnListResponse(this.isbnList);

  factory IsbnListResponse.fromJson(Map<String, dynamic> json){

    var isbnListJson = json["isbn-list"] as List;
    print("ISBN LIST JSON");
    print(json["isbn-list"]);
    List<IsbnList> isbnListList = isbnListJson.map((e) => IsbnList.fromJson(e)).toList();
    return IsbnListResponse(isbnListList);
  }
}

