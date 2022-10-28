import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, bool value = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giriş Yap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Divider(
              color: Colors.black,
              endIndent: 150,
              thickness: 1,
            ),
            const SizedBox(height: 50),
            const TextField(
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  hintText: 'Email Adresi',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.password),
                  hintText: 'Şifre',
                  border: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    // ignore: avoid_print
                    onPressed: () => {debugPrint('A')},
                    child: const Text(
                      'Şifremi Unuttum',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
            Row(
              children: const [
                Checkbox(
                  value: true,
                  onChanged: null,
                ),
                Text('Beni Hatırla')
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      onPressed: () => {},
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () => {},
                      child: const Text('Kayıt Ol',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 18)))
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
