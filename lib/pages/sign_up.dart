import 'package:flutter/material.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: ProjectUtility().customgradient(),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 50 * 40,
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
                str: 'Kayıt Ol',
              ),
              const CustomTextField(hint: 'İsim', a: Icons.person),
              const CustomTextField(hint: 'Soyisim', a: Icons.person),
              const CustomTextField(hint: 'Email', a: Icons.email),
              const CustomTextField(hint: 'Şifre', a: Icons.password),
              Center(
                child: Column(children: [
                  const CustomButton(title: 'Kayıt Ol'),
                  TextButton(
                      onPressed: () => {
                            Navigator.pop(context),
                          },
                      child: const Text('Zaten Hesabım Var',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 18)))
                ]),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

/*
SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTitle(
                str: 'Kayıt Ol',
              ),
              const CustomDivider(),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'İsim', a: Icons.person),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Soyisim', a: Icons.person),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Email', a: Icons.email),
              const SizedBox(height: 25),
              const CustomTextField(hint: 'Şifre', a: Icons.password),
              const SizedBox(height: 50),
              Center(
                child: Column(children: [
                  const CustomButton(title: 'Kayıt Ol'),
                  TextButton(
                      onPressed: () => {
                            Navigator.pop(context),
                          },
                      child: const Text('Zaten Hesabım Var',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 18)))
                ]),
              )
            ],
          ),
        ),
      ),
 */