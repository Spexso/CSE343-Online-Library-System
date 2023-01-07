// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/manager/requests.dart';
import 'package:login_page/model/isbn_list_response.dart';
import 'package:login_page/model/isbn_picture.dart';
import 'package:login_page/model/isbn_profile.dart';
import 'dart:typed_data';
import 'book_page.dart';

import '../model/error_message.dart';

class LibraryPage extends StatefulWidget {
  final String token;

  const LibraryPage({Key? key, required this.token}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _tfBookNameController = TextEditingController();
  String bookNameSearch = "";
  bool isGridView = false;
  bool _isDetailedSearch = false;
  Future<IsbnListResponse> isbnListState() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/isbn-list");
    var data = {
      "name": bookNameSearch,
      "author": "",
      "publisher": "",
      "year-start": "",
      "year-end": "",
      "class-number": "",
      "cutter-number": "",
      "per-page": "5",
      "page": "1"
    };

    var body = json.encode(data);

    var answer = await http.post(url,
        body: body, headers: {"Authorization": "Bearer ${widget.token}"});

    IsbnListResponse resp = IsbnListResponse([]);

    if (answer.statusCode == 200) {
      print("request 200");
      print(json.decode(answer.body));
      resp = await IsbnListResponse.fromJson(
          json.decode(utf8.decode(answer.bodyBytes)));
      print("ISBN LIST RESP");
      print(await resp);
      print(await resp.isbnList[0].name);
      return resp;
    } else if (answer.statusCode == 400) {
      print("request 400");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer.body));
      print(resp.kind);
    }
    return resp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value)=>{bookNameSearch = value, setState(() {})},
            onSubmitted: (value)=>{setState(() {})},
            controller: _tfBookNameController,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Ubuntu'),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(100, 100, 100, 1),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              hintStyle:
                  const TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Kitap Adı Giriniz",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Material(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: const Color.fromRGBO(42, 43, 46, 1),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: (() {
                        setState(() {
                          isGridView = true;
                        });
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.grid_on,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: const Color.fromRGBO(42, 43, 46, 1),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: (() {
                        setState(() {
                          isGridView = false;
                        });
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.list,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Material(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromRGBO(42, 43, 46, 1),
                child: Tooltip(
                  message: "Detaylı Arama",
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: (() {
                      _isDetailedSearch = !_isDetailedSearch;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
             // (_isDetailedSearch) ? Container(color: Colors.red,height: 100,width: 100,) : null
            ],
          ),
        ),

        Expanded(
          child: (isGridView
              ? FutureBuilder<IsbnListResponse>(
                  future: isbnListState(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.5),
                        itemCount: snapshot.data!.isbnList.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BookingGrid(
                              name: snapshot.data!.isbnList[index].name,
                              author: snapshot.data!.isbnList[index].author,
                              publisher:
                                  snapshot.data!.isbnList[index].publisher,
                              picture: snapshot.data!.isbnList[index].picture,
                              classNum:
                                  snapshot.data!.isbnList[index].classNumber,
                              cutterNum:
                                  snapshot.data!.isbnList[index].cutterNumber,
                              isbn: snapshot.data!.isbnList[index].isbn,
                              year: snapshot
                                  .data!.isbnList[index].publicationYear,
                              token: widget.token);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'NO DATA',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Ubuntu'),
                      ));
                    }

                    // By default, show a loading spinner.
                    return Center(
                        child: const CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  })
              : FutureBuilder<IsbnListResponse>(
                  future: isbnListState(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.isbnList.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BookingList(
                              name: snapshot.data!.isbnList[index].name,
                              author: snapshot.data!.isbnList[index].author,
                              publisher:
                                  snapshot.data!.isbnList[index].publisher,
                              picture: snapshot.data!.isbnList[index].picture,
                              classNum:
                                  snapshot.data!.isbnList[index].classNumber,
                              cutterNum:
                                  snapshot.data!.isbnList[index].cutterNumber,
                              isbn: snapshot.data!.isbnList[index].isbn,
                              year: snapshot
                                  .data!.isbnList[index].publicationYear,
                              token: widget.token);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'NO DATA',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Ubuntu'),
                      ));
                    }

                    // By default, show a loading spinner.
                    return Center(
                        child: const CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  },
                )),
        ),
      ],
    );
  }
}

//==============================================================================

class BookingList extends StatefulWidget {
  final String name;
  final String author;
  final String publisher;
  final String picture;
  final String year;
  final String classNum;
  final String cutterNum;
  final String isbn;
  final token;

  const BookingList(
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
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 5 * 2,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(42, 43, 46, 1),
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookPage(
                    name: widget.name,
                    author: widget.author,
                    publisher: widget.publisher,
                    year: widget.year,
                    classNum: widget.classNum,
                    cutterNum: widget.cutterNum,
                    isbn: widget.isbn,
                    picture: widget.picture,
                    token: widget.token,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.memory(base64Decode(widget.picture))),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13, right: 13),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.author,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.publisher,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Ubuntu'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
  }
}

//==============================================================================

class BookingGrid extends StatefulWidget {
  final String name;
  final String author;
  final String publisher;
  final String picture;
  final String year;
  final String classNum;
  final String cutterNum;
  final String isbn;
  final String token;

  const BookingGrid(
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
  State<BookingGrid> createState() => _BookingGridState();
}

class _BookingGridState extends State<BookingGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 50 * 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(42, 43, 46, 1),
          ),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookPage(
                    name: widget.name,
                    author: widget.author,
                    publisher: widget.publisher,
                    year: widget.year,
                    classNum: widget.classNum,
                    cutterNum: widget.cutterNum,
                    isbn: widget.isbn,
                    picture: widget.picture,
                    token: widget.token,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.memory(base64Decode(widget.picture))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Text(
                    widget.author,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Ubuntu'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Text(
                    widget.publisher,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Ubuntu'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
