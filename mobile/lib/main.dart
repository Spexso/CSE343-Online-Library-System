import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}
/*AAAAAAA*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final bool value = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          useMaterial3: true,
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromRGBO(42, 43, 46, 1), // important
              onPrimary: Colors.purple,
              secondary: Colors.purple,
              onSecondary: Colors.purple,
              error: Colors.purple,
              onError: Colors.purple,
              background: Colors.purple,
              onBackground: Colors.purple,
              surface: Colors.brown, //important
              onSurface: Color.fromRGBO(42, 43, 46, 1))), //important
      home: const LoginPage(),
    );
  }
}
