import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

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
              primary: Colors.brown, // important
              onPrimary: Colors.red,
              secondary: Colors.red,
              onSecondary: Colors.red,
              error: Colors.red,
              onError: Colors.red,
              background: Colors.red,
              onBackground: Colors.red,
              surface: Colors.brown, //important
              onSurface: Colors.brown)), //important
      home: const LoginPage(),
    );
  }
}
