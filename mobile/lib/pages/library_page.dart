// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/manager/requests.dart';
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
  bool isGridView = false;

  //String bookName = "";
  //String bookAuthor = "";
  //String bookPublisher = "";

  //String pictureBase64 = "";
  var pictureList = List<String>.filled(4, "", growable: false);
  var nameList = List<String>.filled(4, "", growable: false);
  var authorList = List<String>.filled(4, "", growable: false);
  var publisherList = List<String>.filled(4, "", growable: false);
  var yearList = List<String>.filled(4, "", growable: false);
  var classNumList = List<String>.filled(4, "", growable: false);
  var cutterNumList = List<String>.filled(4, "", growable: false);
  var isbnList = ["0201558025", "0486240614", "0761997601", "9783527308378"];

  Future<List<IsbnProfile>> isbnProfileState() async {

    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/isbn-profile");

    var data = List.filled(4, {"isbn": "0201558025"});

    data[0] = {
      "isbn": "0201558025",
    };
    data[1] = {
      "isbn": "0486240614",
    };
    data[2] = {
      "isbn": "0761997601",
    };
    data[3] = {
      "isbn": "9783527308378",
    };

    var body = List.filled(4, json.encode(data[0]));

    for (int i=0;i<4;++i) {
      body[i] = json.encode(data[i]);
    }
    var answer = List.filled(4, await http.post(
        url,
        body: body[0],
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    ));
    print("in isbn:");
    print(widget.token);
    for (int i=0;i<4;++i) {
      answer[i] = await http.post(
          url,
          body: body[i],
          headers: {
            "Authorization": "Bearer ${widget.token}"}
      );
    }
    var resp = List.filled(4, IsbnProfile("", "", "", "", "", "", ""));

    if((answer[0].statusCode == 200) && (answer[1].statusCode == 200) && (answer[2].statusCode == 200) && (answer[3].statusCode == 200)){
      print("isbn profile success");
      for(int i=0;i<4;++i)
      {
        resp[i] = IsbnProfile.fromJson(json.decode(answer[i].body));
      }

    }
    else if((answer[0].statusCode == 400) || (answer[1].statusCode == 400) || (answer[2].statusCode == 400) || (answer[3].statusCode == 400)){
      print("isbn profile not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer[0].body));
      print(resp.message);
    }
    return resp;
  }

  @override
  void initState() {
    isbnProfileState().then((value){

    });
    //isbnPicture().then((value){
    //});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return isGridView
        ? ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
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
                    hintStyle: const TextStyle(color: Colors.white),
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
                            log("A");
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
                  ],
                ),
              ),

              FutureBuilder<List<IsbnProfile>>(
                future: isbnProfileState(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,      childAspectRatio: 0.5),
                      itemCount: snapshot.data!.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BookingGrid(
                            name: snapshot.data![index].name,
                            author: snapshot.data![index].author,
                            publisher: snapshot.data![index].publisher,
                            picture: snapshot.data![index].picture,
                            classNum: snapshot.data![index].classNumber,
                            cutterNum: snapshot.data![index].cutterNumber,
                            isbn: isbnList[index],
                            year: snapshot.data![index].publicationYear
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return Center(child: const CircularProgressIndicator(color: Colors.white,));
                },
              ),
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
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
                    hintStyle: const TextStyle(color: Colors.white),
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
                            log("A");
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
                  ],
                ),
              ),
              FutureBuilder<List<IsbnProfile>>(
                future: isbnProfileState(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BookingList(
                            name: snapshot.data![index].name,
                            author: snapshot.data![index].author,
                            publisher: snapshot.data![index].publisher,
                            picture: snapshot.data![index].picture,
                            classNum: snapshot.data![index].classNumber,
                            cutterNum: snapshot.data![index].cutterNumber,
                            isbn: isbnList[index],
                            year: snapshot.data![index].publicationYear
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return Center(child: const CircularProgressIndicator(color: Colors.white,));
                },
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
  const BookingList({Key? key,
    required this.name, required this.author,
    required this.publisher, required this.picture,
    required this.classNum, required this.cutterNum,
    required this.isbn, required this.year}) : super(key: key);

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
                    builder: (context) =>
                        BookPage(
                          name: widget.name,
                          author: widget.author,
                          publisher: widget.publisher,
                          year: widget.year,
                          classNum: widget.classNum,
                          cutterNum: widget.cutterNum,
                          isbn: widget.isbn,
                          picture: widget.picture,
                        ),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200, width: 150,
                      child: Image.memory(base64Decode(widget.picture))
                  ),
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
                          style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.author,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.publisher,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
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
  const BookingGrid({Key? key,
    required this.name, required this.author,
    required this.publisher, required this.picture,
    required this.classNum, required this.cutterNum,
    required this.isbn, required this.year}) : super(key: key);

  @override
  State<BookingGrid> createState() => _BookingGridState();
}

class _BookingGridState extends State<BookingGrid> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width / 5 * 2,
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
                  ),),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 200, width: 150,
                    child: Image.memory(base64Decode(widget.picture))
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7.0, left: 8, right: 8),
                  child: Text(
                    widget.name,
                    style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 8, right: 8),
                  child: Text(
                    widget.author,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    widget.publisher,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
