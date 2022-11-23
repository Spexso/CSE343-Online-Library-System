// ignore_for_file:  avoid_unnecessary_containers

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List swiperList = [
    "https://cdnuploads.aa.com.tr/uploads/Contents/2020/02/19/thumbs_b_c_5b0f5fae30f09e6fb515cd287f8449f3.jpg?v=122557",
    "https://i.pinimg.com/originals/27/7e/42/277e42b95643c0d9f41ed3d61a1d5f6a.jpg",
    "https://cdnuploads.aa.com.tr/uploads/sirkethaberleri/Contents/2021/08/12/thumbs_b_c_9cedd6d922ff9ae3c993b24c7db9acc9.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //title: Text(''),
      //),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 11),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: SizedBox(
                    width: double.infinity,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          swiperList[index],
                          fit: BoxFit.fill,
                        );
                      },
                      itemCount: 3,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 160, top: 10, bottom: 10),
                child: Text("Merhaba Berru!",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 20),
                child: TextField(
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Kitap ara',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 18),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.5, bottom: 7.5),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 19.0),
                              elevation: 5,
                              shadowColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.menu_book_rounded,
                                  color: Colors.white,
                                  size: 75,
                                ),
                                Text(
                                  'KİTAPLIK',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.5, bottom: 7.5),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 19.0),
                              elevation: 5,
                              shadowColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () {},
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.bookmark_border_rounded,
                                  color: Colors.white,
                                  size: 75,
                                ),
                                Text(
                                  'KAYDEDİLDİ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.5, top: 7.5),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 19.0),
                              elevation: 5,
                              shadowColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 75,
                                ),
                                Text(
                                  'TALEPLER',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.5, top: 7.5),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 19.0),
                              elevation: 5,
                              shadowColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.white,
                                  size: 75,
                                ),
                                Text(
                                  'PROFİL',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*
              SizedBox(
                height: 100,
                width: 100,
                child: Container(
                  child: Text("heyyy"),
                  color: Colors.lightGreenAccent,
                ),
              ),

              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){

                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("kutucuk"),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
