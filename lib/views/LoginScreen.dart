// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flopkart/views/SignUpScreen.dart';
import 'package:flopkart/views/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Login"),
            automaticallyImplyLeading: false,
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
                    controller: loginEmailController,
                    decoration: InputDecoration(
                      hintText: 'UserEmail',
                      enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: loginPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password),
                      enabledBorder: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var loginEmail = loginEmailController.text.trim();
                      var loginPassword = loginPasswordController.text.trim();
                      try {
                        final User? firebaseUser = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: loginEmail, password: loginPassword))
                            .user;
                        if (firebaseUser != null) {
                          Get.to(() => HomeScreen());
                        } else {
                          AlertDialog(
                            content: Text("Check Password"),
                          );
                          print("Check Email and Password");
                        }
                      } on FirebaseAuthException catch (e) {
                        print("Error $e");
                      }
                    },
                    child: Text("Login")),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Forgot Password"),
                  )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SignUpScreen());
                  },
                  child: Container(
                    child: Card(
                        color: Color.fromRGBO(255, 100, 50, 0.8),
                        shadowColor: Color.fromRGBO(50, 41, 38, 0.8),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Signup if you donot have",
                              selectionColor:
                                  Color.fromARGB(255, 235, 227, 225),
                            ))),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
