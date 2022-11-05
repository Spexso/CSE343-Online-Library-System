import 'package:flutter/material.dart';
import 'package:login_page/pages/forgot_password.dart';
import 'sign_up.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, bool value = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: ProjectUtility().customgradient(),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 5 * 2.5,
            width: MediaQuery.of(context).size.width / 5 * 4,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomTitle(
                  str: 'Giriş Yap',
                ),
                const CustomTextField(hint: 'Email Adresi', a: Icons.email),
                const CustomTextField(hint: 'Şifre', a: Icons.password),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Checkbox(value: true, onChanged: null),
                        Text("Beni Hatırla")
                      ],
                    ),
                    TextButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()),
                              )
                            },
                        child: const Text(
                          'Şifremi Unuttum',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        )),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      const CustomButton(
                        title: 'Giriş Yap',
                      ),
                      TextButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpPage()),
                                )
                              },
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
        ),
      ),
    );
  }
}

class ProjectUtility {
  BoxDecoration customgradient() {
    return const BoxDecoration(
        gradient: LinearGradient(
      colors: [Colors.blue, Colors.brown],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ));
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  const CustomButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: () => {},
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black,
      endIndent: 150,
      thickness: 1,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData a;
  const CustomTextField({
    Key? key,
    required this.hint,
    required this.a,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: Icon(a),
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String str;
  const CustomTitle({
    Key? key,
    required this.str,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        str,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}
