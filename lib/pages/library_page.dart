import 'dart:developer';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool isGridView = false;
  @override
  Widget build(BuildContext context) {
    return isGridView
        ? ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white)),
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
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: const [
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                  BookinGrid(),
                ],
              )
            ],
          )
        : ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white)),
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
              const BookinList(),
              const BookinList(),
              const BookinList(),
              const BookinList(),
              const BookinList(),
              const BookinList(),
              const BookinList(),
              const BookinList(),
            ],
          );
  }
}

class BookinList extends StatelessWidget {
  const BookinList({
    Key? key,
  }) : super(key: key);

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
            onTap: () {},
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      "https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "1984",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "George Orwell",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Can Yayınları",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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

class BookinGrid extends StatelessWidget {
  const BookinGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                child: Image.network(
                    "https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg"),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "1984",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Expanded(
                  child: Text(
                "George Orwell",
                style: TextStyle(color: Colors.white, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              const Expanded(
                child: Text(
                  "Can Yayınları",
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
