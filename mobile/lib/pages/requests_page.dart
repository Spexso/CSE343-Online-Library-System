import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/error_message.dart';
import '../model/isbn_profile.dart';
import '../model/request_book_response.dart';
import 'book_page.dart';

List<String> _nameList = [
  "Designing embedded systems with PIC microcontrollers : principles and applications",
  "Concrete mathematics",
  "An introduction to information theory : symbols, signals & noise",
  "1984"
];

List<int> _peopleLeft = [0, 1, 7, 11];

List<String> _imageList = [
  "https://m.media-amazon.com/images/I/51iVywErBdL.jpg",
  "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1348780612l/112243.jpg",
  "https://m.media-amazon.com/images/I/41IOCu-lwdL._AC_SY1000_.jpg",
  "https://i.dr.com.tr/cache/600x600-0/originals/0000000064038-1.jpg"
];

class RequestsPage extends StatefulWidget {
  final String token;

  const RequestsPage({Key? key, required this.token}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late String name;
  late String left;
  late String image;
  late List<IsbnProfile> profile;

  Future<RequestListResponse> requestListState() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/queued-books");

    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});

    RequestListResponse resp = RequestListResponse([]);

    if (answer.statusCode == 200) {
      print("request 200");
      resp = RequestListResponse.fromJson(json.decode(answer.body));
      return resp;
    } else if (answer.statusCode == 400) {
      print("request 400");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
    }
    return resp;
  }

  Future<bool> MarkPresence() async{
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/mark-presence");

    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});

    if (answer.statusCode == 200) {
      print("request 200");
      return true;
    } else if (answer.statusCode == 400) {
      print("request 400");

    }
    return false;
  }

  String _timestampConverter(timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String dateTime = tsdate.day.toString() +
        "/" +
        tsdate.month.toString() +
        "/" +
        tsdate.year.toString() +
        "-" +
        tsdate.hour.toString() +
        ":" +
        tsdate.minute.toString();
    return dateTime;
  }

  Future<List<IsbnProfile>> ListIsbnProfile() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/isbn-profile");
    var queueData = await requestListState();
    var data = List.filled(
        queueData.requestList.length, {"isbn": queueData.requestList[0].isbn});
    for (int i = 0; i < queueData.requestList.length; ++i) {
      data[i] = {"isbn": queueData.requestList[i].isbn};
    }
    var bodyList =
        List.filled(queueData.requestList.length, json.encode(data[0]));
    for (int i = 0; i < queueData.requestList.length; ++i) {
      bodyList[i] = json.encode(data[i]);
    }
    var answerlist = List.filled(
        queueData.requestList.length,
        await http.post(url,
            body: bodyList[0],
            headers: {"Authorization": "Bearer ${widget.token}"}));
    for (int i = 0; i < answerlist.length; ++i) {
      answerlist[i] = await http.post(url,
          body: bodyList[i],
          headers: {"Authorization": "Bearer ${widget.token}"});
    }
    var respList = List.filled(queueData.requestList.length,
        await IsbnProfile.fromJson(json.decode(answerlist[0].body)));
    for (int i = 0; i < queueData.requestList.length; ++i) {
      respList[i] = await IsbnProfile.fromJson(
          json.decode(utf8.decode(answerlist[i].bodyBytes)));
    }
    return respList;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([ListIsbnProfile(), requestListState()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data![0].length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookPage(
                              name: snapshot.data![0][index].name,
                              author: snapshot.data![0][index].author,
                              publisher: snapshot.data![0][index].publisher,
                              year: snapshot.data![0][index].publicationYear,
                              classNum: snapshot.data![0][index].classNumber,
                              cutterNum: snapshot.data![0][index].cutterNumber,
                              isbn: snapshot.data![0][index].isbn,
                              picture: snapshot.data![0][index].picture,
                              token: widget.token,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 5 * 2,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(42, 43, 46, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              child: SizedBox(
                                  height: 200,
                                  width: 150,
                                  child: Image.memory(base64Decode(
                                      snapshot.data![0][index].picture))),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13, right: 13),
                                    child: Text(
                                      snapshot.data![0][index].name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data![1].requestList[index].position}. Sıradasınız",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {await MarkPresence();},
                                    child: Text("Kitabı Al"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                  (snapshot.data![1].requestList[index]
                                                  .position ==
                                              "1" &&
                                          snapshot.data![1].requestList[index]
                                                  .validUntil !=
                                              "0")
                                      ? Text(
                                          "${_timestampConverter(snapshot.data![1].requestList[index].validUntil)} Tarihine Kadar Alabilirsiniz",
                                          style: TextStyle(color: Colors.white))
                                      : Text(
                                          "Sıranız Gelmedi",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        });
  }
}
