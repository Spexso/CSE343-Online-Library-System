import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'new_home_page.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  final String name;
  final String author;
  final String publisher;
  final String picture;
  final String year;
  final String classNum;
  final String cutterNum;
  final String isbn;
  final String token;
  const BookPage({Key? key,
    required this.name, required this.author,
    required this.publisher, required this.picture,
    required this.classNum, required this.cutterNum,
    required this.isbn, required this.year,required this.token}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}
Future<bool> savedBooks(isbn, token) async {
  var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
  var url = Uri.parse("$urlString/user/save-book");
  var body = String.fromCharCode(34) + isbn + String.fromCharCode(34);
  var answer = await http.post(url ,body: body ,headers: {"Authorization": "Bearer $token"});
  print(body);
  print(answer.statusCode);
  if(answer.statusCode == 200)
    {
      print("TRUE");
      return true;
    }

  print("FALSE");
  return false;
}
class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: (){savedBooks(widget.isbn, widget.token);},
            icon: const Icon(
              Icons.bookmark_outlined,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(60, 60, 60, 1),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Image.memory(base64Decode(widget.picture), fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "by ${widget.author}",
                        style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            fontStyle: FontStyle.italic
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Publisher:  ${widget.publisher}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "ISBN:  ${widget.isbn}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Class Number:  ${widget.classNum}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Cutter Number:  ${widget.cutterNum}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(80, 80, 80, 1)),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              )
                          ),
                          onPressed: () {},
                          child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 35),
                              child: Text(
                                "Talep Et",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}