import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/manager/requests.dart';
import 'package:login_page/model/isbn_profile.dart';

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

  String bookName = "";
  String bookAuthor = "";
  String bookPublisher = "";

  var nameList = List<String>.filled(4, "", growable: false);
  var authorList = List<String>.filled(4, "", growable: false);
  var publisherList = List<String>.filled(4, "", growable: false);


  //======================================================

  Future<void> isbnProfileState() async {

    var url = Uri.parse("http://10.0.2.2:8080/user/isbn-profile");
    var data1 = {
      "isbn": "0201558025",
    };
    var data2 = {
      "isbn": "0486240614",
    };
    var data3 = {
      "isbn": "0761997601",
    };
    var data4 = {
      "isbn": "9783527308378",
    };

    var body1 = json.encode(data1);
    var body2 = json.encode(data2);
    var body3 = json.encode(data3);
    var body4 = json.encode(data4);


    print("in isbn:");
    print(widget.token);

    var answer1 = await http.post(
        url,
        body: body1,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    var answer2 = await http.post(
        url,
        body: body2,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    var answer3 = await http.post(
        url,
        body: body3,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    var answer4 = await http.post(
        url,
        body: body4,
        headers: {
          "Authorization": "Bearer ${widget.token}"}
    );

    IsbnProfile resp1 = IsbnProfile("", "", "", "", "", "");
    IsbnProfile resp2 = IsbnProfile("", "", "", "", "", "");
    IsbnProfile resp3 = IsbnProfile("", "", "", "", "", "");
    IsbnProfile resp4 = IsbnProfile("", "", "", "", "", "");


    if((answer1.statusCode == 200) && (answer2.statusCode == 200) && (answer3.statusCode == 200) && (answer4.statusCode == 200)){
      print("isbn profile success");
      resp1 = IsbnProfile.fromJson(json.decode(answer1.body));
      resp2 = IsbnProfile.fromJson(json.decode(answer2.body));
      resp3 = IsbnProfile.fromJson(json.decode(answer3.body));
      resp4 = IsbnProfile.fromJson(json.decode(answer4.body));


      nameList[0] = resp1.name;
      authorList[0] = resp1.author;
      publisherList[0] = resp1.publisher;

      nameList[1] = resp2.name;
      authorList[1] = resp2.author;
      publisherList[1] = resp2.publisher;

      nameList[2] = resp3.name;
      authorList[2] = resp3.author;
      publisherList[2] = resp3.publisher;

      nameList[3] = resp4.name;
      authorList[3] = resp4.author;
      publisherList[3] = resp4.publisher;

      /*
      bookName = resp.name;
      bookAuthor = resp.author;
      bookPublisher = resp.publisher;
      print("bookkksss");
      print(bookName);
      print(bookAuthor);
      print(bookPublisher); */
    }
    else if((answer1.statusCode == 400) || (answer2.statusCode == 400) || (answer3.statusCode == 400) || (answer4.statusCode == 400)){
      print("isbn profile not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer1.body));
      print(resp.message);

    }
    //return resp;
  }
//======================================================

  @override
  void initState() {
    isbnProfileState();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return isGridView
        ? ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(100, 100, 100, 1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(
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

              GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: nameList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5
                ),
                itemBuilder: (context,index){
                    return BookingGrid(name: nameList[index], author: authorList[index], publisher: publisherList[index],);
                }
              )
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(100, 100, 100, 1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(
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
              ListView.builder(
                itemCount: nameList.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BookingList(name: nameList[index], author: authorList[index], publisher: publisherList[index],);
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
  const BookingList({Key? key,required this.name, required this.author, required this.publisher}) : super(key: key);

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
            onTap: () =>{
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookPage()),
              )
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  //child: Image.network("https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.author,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.publisher,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
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
  const BookingGrid({Key? key,required this.name, required this.author, required this.publisher}) : super(key: key);

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
          onTap: () {},
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                //child: Image.network("https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    widget.name,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.author,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ),
              Expanded(
                child: Text(
                  widget.publisher,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
