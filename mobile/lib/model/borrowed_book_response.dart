import 'package:login_page/model/borrowed_book.dart';

class BorrowedListResponse {

  List<BorrowedList> borrowedList;

  BorrowedListResponse(this.borrowedList);

  factory BorrowedListResponse.fromJson(Map<String, dynamic> json){

    var borrowedListJson = json["borrowed-list"] as List;
    List<BorrowedList> borrowedListList = borrowedListJson.map((e) => BorrowedList.fromJson(e)).toList();
    return BorrowedListResponse(borrowedListList);
  }
}

