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
      appBar: AppBar(),
      body: Container(
        color: const Color.fromRGBO(42, 43, 46, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://kbimages1-a.akamaihd.net/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg",
              height: MediaQuery.of(context).size.width,


            ),
            const Text("Name"),
            const Text("Author"),
            const Text("Publisher"),
            ElevatedButton(
                onPressed: () {},
                child: const Center(
                  child: Text("Sıraya Gir"),
                ))
          ],
        ),
      ),
    );
  }
}
