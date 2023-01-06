import 'package:login_page/model/request_list.dart';

class RequestListResponse {

  List<RequestList> requestList;

  RequestListResponse(this.requestList);

  factory RequestListResponse.fromJson(Map<String, dynamic> json){

    var requestListJson = json["entries"] as List;
    List<RequestList> requestListList = requestListJson.map((e) => RequestList.fromJson(e)).toList();
    return RequestListResponse(requestListList);
  }
}