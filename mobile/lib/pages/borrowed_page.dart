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

  Future<BorrowedListResponse> borrowedListState() async{
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/borrowed-books");

    var answer = await http
        .post(url, headers: {"Authorization": "Bearer ${widget.token}"});
    
    BorrowedListResponse resp = BorrowedListResponse([]);

    if (answer.statusCode == 200) {
      print("boorowed request 200");
      resp = BorrowedListResponse.fromJson(json.decode(answer.body));
      print("answer body");
      print(answer.body);
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
      body: Center(
        child: Column(
          children: [
            FutureBuilder<BorrowedListResponse>(
                future: borrowedListState(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.borrowedList.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return Container(
                            child: Column(
                              children: [
                                Text("${snapshot.data!.borrowedList[index].name}"
                                    "\nkitabının son teslim tarihi\n"
                                    "${snapshot.data!.borrowedList[index].dueDate}"
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator(color: Colors.white,));
                }
            ),
          ],
        ),
      ),
    );
  }
}
