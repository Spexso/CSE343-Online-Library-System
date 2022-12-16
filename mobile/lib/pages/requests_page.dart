import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _RequestsInList(
          left: "3",
          name: "1984",
        );
      },
    );
  }
}

class _RequestsInList extends StatefulWidget {
  final String name;
  final String left;

  const _RequestsInList({
    Key? key,
    required this.name,
    required this.left,
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
                    height: MediaQuery.of(context).size.width / 5 * 2,
                    width: null,
                    child: Image.network(
                        "https://i.dr.com.tr/cache/600x600-0/originals/0000000064038-1.jpg")),
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
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${widget.left} people left",
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
