import 'package:firebase_auth/firebase_auth.dart';
import 'package:flopkart/views/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgetPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Forgot Password?"),
            // actions: [
            //   Icon(Icons.more_vert_outlined),
            // ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(child: Lottie.asset("assets/72883-login-page.json")),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var forgotEmail = forgetPasswordController.text.trim();
                      try {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: forgotEmail)
                            .then((value) => {
                                  // ignore: avoid_print
                                  print("Email sent"),
                                  // ignore: prefer_const_constructors
                                  Get.off(() => LoginScreen()),
                                });
                      } on FirebaseAuthException catch (e) {
                        print("Error $e");
                      }
                    },
                    // ignore: prefer_const_constructors
                    child: Text("Get Verification Mail")),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          )),
    );
  }
}
