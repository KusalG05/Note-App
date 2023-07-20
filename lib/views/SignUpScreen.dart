import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flopkart/views/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../services/signupservice.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("SignUp"),
            // actions: [
            //   Icon(Icons.more_vert_outlined),
            // ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Lottie.asset("assets/72883-login-page.json",
                        height: 200.0)),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle),
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
                    controller: userEmailController,
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
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: userPhoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
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
                    controller: userPasswordController,
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
                    onPressed: () async{
                      var userName = userNameController.text.trim();
                      var userPhone = userPhoneController.text.trim();
                      var userPassword = userPasswordController.text.trim();
                      var userEmail = userEmailController.text.trim();
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: userEmail, password: userPassword)
                          .then((value) => {
                                log("User created"),
                                signUpUser(userName, userPhone, userEmail, userPassword),
                              });
                    },
                    child: Text("SignUp")),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginScreen());
                  },
                  child: Container(
                    child: Card(
                        color: Color.fromRGBO(255, 100, 50, 0.8),
                        shadowColor: Color.fromRGBO(50, 41, 38, 0.8),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Already account there.. login",
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
