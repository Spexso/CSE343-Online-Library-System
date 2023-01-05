import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_page/manager/requests.dart';
import 'package:login_page/model/isbn_picture.dart';
import 'package:login_page/model/isbn_profile.dart';
import 'package:login_page/model/saved_book_list.dart';
import 'dart:typed_data';



import '../model/error_message.dart';

class SavedPage extends StatefulWidget {
  final String token;
  const SavedPage({Key? key, required this.token}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  var pictureList = List<String>.filled(4, "", growable: false);
  var nameList = List<String>.filled(4, "", growable: false);

  Future<List<String>> savedBooks() async {
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/saved-books");
    var answer = await http.post(url , headers: {"Authorization": "Bearer ${widget.token}"});
    var isbnList = SavedBooks(books: [""]);
    if(answer.statusCode == 200)
      {
        isbnList = SavedBooks.fromJson(json.decode(answer.body));

        return isbnList.books;
      }
    print(isbnList.toList());
    return isbnList.books;



  }

  Future<List<IsbnProfile>> isbnProfileState() async {
    print("in isbnProfileState");
    var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
    var url = Uri.parse("$urlString/user/isbn-profile");
    var list = await savedBooks();
    var data = List.filled(list.length,{"isbn" : list[0]});
    for(int i=0;i<list.length;++i)
      {
        data[i] = {"isbn" : list[i]};
      }
    var body = List.filled(list.length, json.encode(data));
    for(int i=0;i<list.length;++i)
    {
      body[i] = json.encode(data[i]);
    }
    print(body);
    print(body[0].runtimeType);
    var answer = List.filled(list.length, await http.post(url, body: body[0],headers: {"Authorization": "Bearer ${widget.token}"} ));
    for(int i=0; i<list.length;++i)
      {
        answer[i] = await http.post(url, body: body[i],headers: {"Authorization": "Bearer ${widget.token}"} );
      }
    bool flag = true;
    for (int i=0;i<list.length;++i)
    {
      if(answer[i].statusCode == 400)
      {
        flag = false;
      }
    }

    var resp = List.filled(list.length, IsbnProfile("", "", "", "", "", "", ""));
    if(flag){
      print("isbn profile success");
      for(int i=0;i<list.length;++i)
      {
        resp[i] = IsbnProfile.fromJson(json.decode(answer[i].body));
      }
    }
    else{
      print("isbn profile not success");
      ErrorMessage resp = ErrorMessage.fromJson(json.decode(answer[0].body));
      print(resp.kind);
    }

    return resp;
  }


  @override
  void initState() {
    savedBooks().then((value) => null);
    //isbnPicture().then((value){
    //});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<IsbnProfile>>(
      future: isbnProfileState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _BookInList(
                name: snapshot.data![index].name,
                picture: snapshot.data![index].picture,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child:  CircularProgressIndicator(color: Colors.white,));
      },
    );



  }
}


class _BookInList extends StatefulWidget {
  final String name;
  final String picture;
  const _BookInList({
    Key? key,
    required this.name,
   required this.picture,
  }) : super(key: key);

  @override
  State<_BookInList> createState() => _RequestsInListState();
}

bool style = false;
Future<bool> unsaveBook(isbn, token) async {
  var urlString = dotenv.env['API_URL'] ?? "API_URL not found";
  var url = Uri.parse("$urlString/user/unsave-book");
  var data = {"isbn" : isbn};
  var body = await json.encode(data);
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
class _RequestsInListState extends State<_BookInList> {
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: SizedBox(
                    height: 200,
                    width: 150,
                    child: Image.memory(base64Decode(widget.picture))),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        widget.name,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(Icons.add),
                            style: buildButtonStyle(),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(Icons.delete),
                            style: buildButtonStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle buildButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(
            const BorderSide(color: Colors.transparent)),
        shape: MaterialStateProperty.all(const CircleBorder()));
  }

  TextStyle buildTextStyle() => const TextStyle(color: Colors.black);


}
