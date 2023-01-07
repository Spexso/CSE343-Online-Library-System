import 'package:flutter/material.dart';
import 'login_page.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

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
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomTitle(str: 'Şifremi Unuttum'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(42, 43, 46, 1),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: const TextStyle(color: Colors.white,
                            fontFamily: 'Ubuntu'),
                        suffixIcon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: "Email Address",

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              const Center(child: CustomButton(title: 'Sıfırlama Maili Gönder'))
            ],
          ),
        ),
      ),
    ));
  }
}
