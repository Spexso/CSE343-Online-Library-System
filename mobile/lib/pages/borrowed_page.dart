import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/borrowed_book_response.dart';
import '../model/error_message.dart';

class BorrowedPage extends StatefulWidget {
  final String token;

  const BorrowedPage({Key? key, required this.token}) : super(key: key);

  @override
  State<BorrowedPage> createState() => _BorrowedPageState();
}

class _BorrowedPageState extends State<BorrowedPage> {
  Future<BorrowedListResponse> borrowedListState() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/borrowed-books");

    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});

    BorrowedListResponse resp = BorrowedListResponse([]);

    if (answer.statusCode == 200) {
      print("boorowed request 200");
      resp = BorrowedListResponse.fromJson(
          json.decode(utf8.decode(answer.bodyBytes)));
      for (int i = 0; i < resp.borrowedList.length; ++i) {
        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(resp.borrowedList[i].dueDate) * 1000);
        resp.borrowedList[i].dueDate = tsdate.day.toString() +
            "/" +
            tsdate.month.toString() +
            "/" +
            tsdate.year.toString() +
            "-" +
            tsdate.hour.toString() +
            ":" +
            tsdate.minute.toString();
      }
      return resp;
    } else if (answer.statusCode == 400) {
      print("request 400");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
    }
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(42, 43, 46, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<BorrowedListResponse>(
          future: borrowedListState(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.borrowedList.length,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(42, 43, 46, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: const Color.fromRGBO(80, 80, 80, 1),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                snapshot.data!.borrowedList[index].name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const Divider(
                              color: Color.fromRGBO(42, 43, 46, 1),
                              thickness: 2,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Kitabının Son Teslim Tarihi",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const Divider(
                              color: const Color.fromRGBO(42, 43, 46, 1),
                              thickness: 2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                snapshot.data!.borrowedList[index].dueDate,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Ubuntu'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'NO DATA',
                style: TextStyle(
                    color: Colors.white, fontSize: 15, fontFamily: 'Ubuntu'),
              ));
            }
            // By default, show a loading spinner.
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }),
    );
  }
}
