import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(42, 43, 46, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Notification(
                  str: "NameNameNameNameNameNameNameNameNameNameNameName"),
              Notification(str: "Name"),
              Notification(str: "Name"),
              Notification(str: "Name"),
              Notification(str: "Name"),
              Notification(str: "Name"),
              Notification(str: "Name"),
            ],
          ),
        ),
      ),
    );
  }
}

class Notification extends StatelessWidget {
  final String str;

  const Notification({Key? key, required this.str}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 110,
        width: MediaQuery.of(context).size.width,

        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              str,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Divider(
              color: Color.fromRGBO(42, 43, 46, 1),
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
