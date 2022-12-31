import 'package:flutter/material.dart';

List<String> _nameList = [
  "Designing embedded systems with PIC microcontrollers : principles and applications",
  "Concrete mathematics",
  "An introduction to information theory : symbols, signals & noise",
  "1984"
];

List<int> _peopleLeft = [0, 1, 7, 11];

List<String> _imageList = [
  "https://m.media-amazon.com/images/I/51iVywErBdL.jpg",
  "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1348780612l/112243.jpg",
  "https://m.media-amazon.com/images/I/41IOCu-lwdL._AC_SY1000_.jpg",
  "https://i.dr.com.tr/cache/600x600-0/originals/0000000064038-1.jpg"
];


class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}



class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _RequestsInList(
          left: _peopleLeft[index].toString(),
          name: _nameList[index],
          image: _imageList[index],
        );
      },
    );
  }
}

class _RequestsInList extends StatefulWidget {
  final String name;
  final String left;
  final String image;

  const _RequestsInList({
    Key? key,
    required this.name,
    required this.left,
    required this.image,
  }) : super(key: key);

  @override
  State<_RequestsInList> createState() => _RequestsInListState();
}

bool style = false;

class _RequestsInListState extends State<_RequestsInList> {
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
                    child: Image.network(
                        widget.image)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      "${widget.left} kişi kaldı",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Icon(Icons.add),
                          style: buildButtonStyle(),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Icon(Icons.delete),
                          style: buildButtonStyle(),
                        ),
                      ],
                    ),
                  ],
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

/*ButtonStyle buildButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      fixedSize: MaterialStateProperty.all(const Size(110, 20)),
    );
  }*/
}

/*    First Prototype
Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: buildButtonStyle(),
                                      onPressed: () {},
                                      child: Text(
                                        "Kitabı Al",
                                        style: buildTextStyle(),
                                      )),
                                  ElevatedButton(
                                      style: buildButtonStyle(),
                                      onPressed: () {},
                                      child: Text(
                                        "Sıradan Çık",
                                        style: buildTextStyle(),
                                      ))
                                ],
                              ),
                            )



 */
