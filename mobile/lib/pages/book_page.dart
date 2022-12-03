import 'package:flutter/material.dart';
import 'new_home_page.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
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
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_outlined,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(60, 60, 60, 1),
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                "https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Author",
                        style: TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Publisher",
                        style: TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(80, 80, 80, 1)),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(42, 43, 46, 1),
                              )),
                          onPressed: () {},
                          child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 35),
                              child: Text(
                                "Talep Et",
                                style: TextStyle(fontSize: 20),
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