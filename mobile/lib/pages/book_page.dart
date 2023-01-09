import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/error_message.dart';
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

  const BookPage(
      {Key? key,
      required this.name,
      required this.author,
      required this.publisher,
      required this.picture,
      required this.classNum,
      required this.cutterNum,
      required this.isbn,
      required this.year,
      required this.token})
      : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}





class _BookPageState extends State<BookPage> {

  String? errorMessage;

  String convertErrorMessage(String message) {
    switch (message) {
      case 'err-isbn-not-exist':
        return 'ISBN mevcut değildir.';
      // enqueue errors
      case 'err-user-suspended':
        return 'Hesabınızda ceza var. Talep etmek için lütfen adminle iletişime geçin.';
      case 'err-past-due':
        return 'past due';
      case 'err-user-in-queue':
        return 'Kitap zaten talepler listenizdedir.';
      case 'err-already-borrowed':
        return 'Kitap zaten sizdedir.';
      // dequeue errors
      case 'err-user-not-in-queue':
        return 'Kitap talepli değildir.';
      // save errors
      case 'err-book-is-saved':
        return 'Kitap zaten kaydedilenler listenizdedir.';
      // unsave errors
      case 'err-book-is-not-saved':
        return 'Kitap kayıtlı değildir.';
      default:
        return 'Bilinmeyen bir hata oluştu.';
    }
  }

  Future<bool> saveBook(isbn, token) async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/save-book");
    var data = {"isbn": isbn};
    var body = await json.encode(data);
    var answer = await http
        .post(url, body: body, headers: {"Authorization": "Bearer $token"});

    if (answer.statusCode == 200) {
      print("TRUE");
      return true;
    }
    else if(answer.statusCode == 400){
      print("FALSE");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      errorMessage = convertErrorMessage(resp.kind);
      print(errorMessage);
      return false;
    }

    return false;
  }

  Future<bool> unsaveBook(isbn, token) async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/unsave-book");
    var data = {"isbn": isbn};
    var body = await json.encode(data);
    var answer = await http
        .post(url, body: body, headers: {"Authorization": "Bearer $token"});

    if (answer.statusCode == 200) {
      print("TRUE ");
      return true;
    }
    else if(answer.statusCode == 400){
      print("FALSE");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      errorMessage = convertErrorMessage(resp.kind);
      print(errorMessage);
      return false;
    }
    return false;
  }

  Future<bool> enqueueBook(isbn, token) async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/enqueue");
    var data = {"isbn": isbn};
    var body = await json.encode(data);
    var answer = await http
        .post(url, body: body, headers: {"Authorization": "Bearer $token"});
    if (answer.statusCode == 200) {
      print("TRUE enqueue");
      return true;
    }
    else if(answer.statusCode == 400){
      print("FALSE ENQU");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      errorMessage = convertErrorMessage(resp.kind);
      print(errorMessage);
      return false;
    }

    return false;
  }

  Future<bool> dequeueBook(isbn, token) async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/dequeue");
    var data = {"isbn": isbn};
    var body = await json.encode(data);
    var answer = await http
        .post(url, body: body, headers: {"Authorization": "Bearer $token"});

    if (answer.statusCode == 200) {
      print("TRUE dequeue");
      return true;
    }
    else if(answer.statusCode == 400){
      print("FALSE DEQU");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      errorMessage = convertErrorMessage(resp.kind);
      print(errorMessage);
      return false;
    }

    return false;
  }

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
            onPressed: () async {
              var ans = await unsaveBook(widget.isbn, widget.token);
              if(ans){
                const snackBar = SnackBar(
                  content: Text('Kayıtlardan çıkarma başarılı!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                final snackBar = SnackBar(
                  content: Text(errorMessage!),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(
              Icons.bookmark_outline,
            ),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () async {
              var ans = await saveBook(widget.isbn, widget.token);
              if(ans){
                const snackBar = SnackBar(
                  content: Text('Kaydetme başarılı!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                final snackBar = SnackBar(
                  content: Text(errorMessage!),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
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
                child: Image.memory(
                  base64Decode(widget.picture),
                  fit: BoxFit.contain,
                )),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                      ),
                      Text(
                        "by ${widget.author}",
                        style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Publisher:  ${widget.publisher}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "ISBN:  ${widget.isbn}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Class Number:  ${widget.classNum}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Cutter Number:  ${widget.cutterNum}",
                        style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    overlayColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(80, 80, 80, 1)),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(150, 50)),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    )),
                                onPressed: () async {
                                  var ans = await enqueueBook(widget.isbn, widget.token);
                                  if(ans){
                                    const snackBar = SnackBar(
                                      content: Text('Talep etme başarılı!'),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                  else{
                                    final snackBar = SnackBar(
                                      content: Text(errorMessage!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: const Text(
                                  "Talep Et",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black,
                                      fontFamily: 'Ubuntu'),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    overlayColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(80, 80, 80, 1)),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(150, 50)),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    )),
                                onPressed: () async {
                                  var ans = await dequeueBook(widget.isbn, widget.token);
                                  if(ans){
                                    const snackBar = SnackBar(
                                      content: Text('Talep iptali başarılı!'),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                  else{
                                    final snackBar = SnackBar(
                                      content: Text(errorMessage!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: const Text(
                                  "Talep İptal",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black,
                                      fontFamily: 'Ubuntu'),
                                )),
                          ],
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
