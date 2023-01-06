import 'dart:math';

import 'package:login_page/model/isbn_list.dart';

class IsbnListResponse {

  List<IsbnList> isbnList;

  IsbnListResponse(this.isbnList);

  factory IsbnListResponse.fromJson(List<dynamic> json){

    //var isbnListJson = json["isbn-list"] as List;

    List<IsbnList> isbnListList = json.map((e) => IsbnList.fromJson(e)).toList();
    return IsbnListResponse(isbnListList);
  }
}

